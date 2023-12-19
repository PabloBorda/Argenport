
#!/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'mechanize'
require 'logger'
require 'mysql'
require './Crawler.rb'
require './Product.rb'
require 'date'

class String
  
    def filter_shit
      return (!include? "á" and
              !include? "é" and
              !include? "í" and
              !include? "ó" and
              !include? "ú" and
              !include? "ü" and
              !include? "@" and
              !include? "!" and
              include? "mercado" and
              !include? "..." and
              !include? "mailto" and
              include? "http" and
              !include? "listado")
      
    end
    
  
    def is_integer?
       !!(self =~ /^[-+]?[0-9]+$/)
    end
end


class MercadoLibre < Crawler

  
  # http://www.mercadolibre.com.ar/jm/ml.allcategs.AllCategsServlet    ["MLPT","http://www.mercadolivre.pt/jm/ml.allcategs.AllCategsServlet"],
  #["MLBR","http://www.mercadolivre.com.br/jm/ml.allcategs.AllCategsServlet"],

  
  def initialize
    super
    @rooturls = [
                  ["MLCO","http://www.mercadolibre.com.co/jm/ml.allcategs.AllCategsServlet"],["MLCR","http://www.mercadolibre.co.cr/jm/ml.allcategs.AllCategsServlet"],["MLCL","http://www.mercadolibre.cl/jm/ml.allcategs.AllCategsServlet"],["MLDO","http://www.mercadolibre.com.do/jm/ml.allcategs.AllCategsServlet"],["MLEC","http://www.mercadolibre.com.ec/jm/ml.allcategs.AllCategsServlet"],["MLMX","http://www.mercadolibre.com.mx/jm/ml.allcategs.AllCategsServlet"],["MLPA","http://www.mercadolibre.com.pa/jm/ml.allcategs.AllCategsServlet"],["MLPE","http://www.mercadolibre.com.pe/jm/ml.allcategs.AllCategsServlet"],["MLUY","http://www.mercadolibre.com.uy/jm/ml.allcategs.AllCategsServlet"],["MLVE","http://www.mercadolibre.com.ve/jm/ml.allcategs.AllCategsServlet"],["MLAR","http://www.mercadolibre.com.ar/jm/ml.allcategs.AllCategsServlet"]]
  end
  
  
  def is_a_product?(page)
    return ((page.uri.to_s.include? "articulo.") and (page.parser.xpath("/html/body/div[4]/div[2]/dl[1]/dd/strong").to_s.include? "price principal") and (page.parser.xpath("/html/body/div[2]/p/span").to_s.include? "Publicación #"))
  end

  
  def update_all_products
    res = @dbh.query "select link,updated,count(sales.id),avoid from products,sales where (sales.product = products.id) and (TIMESTAMPDIFF(DAY,DATE_ADD(NOW(), INTERVAL 1 HOUR),updated)>=-3) group by products.id order by updated desc,count(sales.id) desc;"
    puts "THERE ARE " + res.num_rows.to_s + " ELEMENTS TO UPDATE."
    
    count = 0
    count_total = 0
    while row = res.fetch_row do
      if (row[3].to_s.eql? "0")
        begin
          page = $agent.get(URI.encode(row[0]))
        rescue => e
          puts "Exception, but doesnt matter, keep crawling!"
        end
        if is_a_product? page
          puts "Updating product " + count.to_s + " of " + res.num_rows.to_s + " : " + URI.encode(row[0])
	  update_product(page)
        else
          puts "URL " + count.to_s + " " + URI.encode(row[0]).to_s + " updated on " +  row[1].to_s + " is not a product.Setting avoid flag true"
          @dbh.query "update products set avoid=true where products.link like \'"  + row[0].to_s + "'\;"
        end
        count = count + 1
      else
        puts row[0].to_s + " publication finished."
      end
    end
	#how_many_to_update = Integer(Integer(res.num_rows) / 500);
	#puts "How many chunks of 500 products are we updating in parallel? " + "They are " + how_many_to_update.to_s
	#how_many_to_update.times do
	#  |i|
       #  if i==0
       #    a = 500
       #    b = 1000
       #  else
	#    a = (i-1) * 500
	#    b = i * 500
       #  end
       #   @threads.push(Thread.new()do
       #      puts "LAUNCHING UPDATE PRODUCT FROM " + a.to_s + " TO " + b.to_s 
             
                                
       #      update_in_parallel(a,b)
	#  end)
      
	  
	#end
	#@threads.each { |t| t.join }
	
	
  end
  

  
  

  def get_product_from_page(page)

      product = Product.new
      doc = Hpricot(open(page.uri))
      price_section = doc.search("strong[@class=\"price principal\"]").to_s
    
      sup = doc.search("strong[@class=\"price principal\"]/sup").inner_text

      p2tmp = Hpricot(doc.search("strong[@class=\"price principal\"]").to_s).inner_text.delete("$").delete("U").delete("S")[1..-4]
      p2 = "0"
      if !p2tmp.nil?
        p2 = p2tmp.lstrip.delete "."
      end
      price_str = p2 + "." +  sup
      if price_str[-1,1]  == '.'
	price_str = price_str[0..-2]
      end
      if price_str == ""
        price_str = "-1"
      end
      if price_str.include? "Precio"
        price_str = "-1"
      end
      if price_str.include? ","
	price_str = price_str.delete ","
      end
      if price_str.include? "BsF"
	price_str = price_str.delete "BsF"
      end
      if price_str.include? "/ "
	price_str = price_str.delete "/ "
      end
      if price_str.include? "\302\242"
	price_str = price_str.delete "\302\242"
      end
      if price_str.include? "B"
	price_str = price_str.delete "B"
      end
      if price_str.include? "\342\202\254"
	price_str = price_str.delete "\342\202\254"
      end
      
      price = Float(price_str)
      if (price_section.include? "U$S")
        currency = "U$S"
        price_section = price_section.delete "U$S"
      else
        currency = "$"
      end
      sold_node =  doc.search("dl[@class=\"moreInfo\"]/dd")[2]
      sold = "0"
      if !sold_node.nil?
        sold = sold_node.inner_text[0..-29]
      end
      if sold.nil? or sold == "" or !sold.is_integer?
        sold = 0
      end
      sold = Integer(sold)
      title = page.title().to_s.delete "'"

      product.title = title.to_s
      product.link = page.uri.to_s 
      product.sold = sold.to_s
      product.localcost = price.to_s
      product.currency = currency
      product.db = @dbh
      
      return product

  end



  def update_product(page)
    if page.uri.to_s.filter_shit and is_a_product?(page)
 
      dbproduct = Product.new @dbh,page.uri.to_s
    
      if dbproduct.id != -1 
        puts "PRODUCT FROM DATABASE: "
        dbproduct.print
  
 
        mlproduct = get_product_from_page(page)
    
        puts " RETRIEVING PRODUCT FOR URL:  " + page.uri.to_s
   
        today_sales = (Integer(mlproduct.sold) - Integer(dbproduct.sold))



	p = "select link from products where (link='" + mlproduct.link.to_s + "') and
	                  (TIMESTAMPDIFF(DAY,DATE_ADD(NOW(), INTERVAL 1 HOUR),updated)<=-1);"
	
	res = @dbh.query p
	puts p
	if res.num_rows > 0		  
          r = "insert into sales (product,amount)
	     values (" + dbproduct.id.to_s + "," + today_sales.to_s + ");"
          q = "update products set sold=" + mlproduct.sold.to_s + ",updated=TIMESTAMP(DATE_ADD(NOW(), INTERVAL 1 HOUR))
	     where (link='" + mlproduct.link.to_s + "') and
	     (TIMESTAMPDIFF(DAY,DATE_ADD(NOW(), INTERVAL 1 HOUR),updated)<=-1);"      
          puts r
	  puts q
	
        
          @dbh.query(r)
	  @dbh.query(q)
        end
      end
    end
  end

  
     
  
  
  
  def crawl_protected(page,level)
    if (level <= 10) and !is_a_product?(page)
       puts "======= LEVEL " + level.to_s + " ========= "
       if page.links.size == 0
	 puts "NO LINKS TO FOLLOW FROM THIS PAGE"
       else
         page.links.each {
          |l|
         if $dont_follow.include? l.to_s or was_visited(l.uri.to_s)
	   puts "VISITED!! AVOIDING: " + l.uri.to_s
	 else	   
            current_page = ""
            if filter_links(l)
              begin
	        if !was_recorded l.uri.to_s      # this is temp , by the time i dont want iit to update products, so I avoid visiting product link
	          current_page = $agent.click(l)	        
	          crawl_protected(current_page,level+1)
	          if !is_a_product? current_page
	 	    puts "Visiting Category: " + current_page.uri.to_s
	            @dbh.query "insert into categories (name) values ('" +  current_page.uri.to_s + "');"
	          end
	        end
              rescue Exception
                puts $!, $@
              rescue Mechanize::UnsupportedSchemeError => e
                puts "Protocol for " + l.to_s + " not supported, not following this link"
              end
	   else
	     puts "AVOIDING " + l.uri.to_s	 
	   end
          end
           }
       end
    else
      if is_a_product? page
        res = @dbh.query("select link from products where (link = '" + page.uri.to_s + "') and (TIMESTAMPDIFF(DAY,DATE_ADD(NOW(), INTERVAL 1 HOUR),updated)<=-1);") 
	if res.num_rows > 0
           row = res.fetch_row
	   if row[0].to_s.eql? page.uri.to_s
	     puts "PRODUCT " + page.uri.to_s + " FOUND ON DATABASE, UPDATING VALUES..." 
             update_product(page)
	   end
	else
	  puts "Adding product to database\n" 
          get_product_data_and_insert_to_db(page)
	end
      end
    end	 
  end 
  
  
  

  private
    def filter_links(link)
      return (!link.uri.to_s.include? "á" and
              !link.uri.to_s.include? "é" and
              !link.uri.to_s.include? "í" and
              !link.uri.to_s.include? "ó" and
              !link.uri.to_s.include? "ú" and
              !link.uri.to_s.include? "ü" and
              !link.uri.to_s.include? "@" and
              !link.uri.to_s.include? "!" and
              link.uri.to_s.include? ".mercado" and
              !link.uri.to_s.include? "..." and
              !link.uri.to_s.include? "mailto" and
              !link.uri.to_s.split("/").last.include? ".")   #means its not a file to download
    end
  
    def was_visited(category)
      res = @dbh.query "select * from categories where name = '" + category.to_s + "';"
      if res.num_rows > 0
	row = res.fetch_row
	row[1].eql? category.to_s
      else
	false
      end
    end
    
    def was_recorded(product)
      res = @dbh.query "select * from products where link = '" + product.to_s + "';"
      if res.num_rows > 0
	row = res.fetch_row
	row[0].eql? product.to_s
      else
	false
      end
    end
	
	
	#updates a range of products so it can be called parallel
	def update_in_parallel(a,b)
	  count = 0
	  res = @dbh.query "select link from products where (TIMESTAMPDIFF(DAY,DATE_ADD(NOW(), INTERVAL 1 HOUR),updated)<=-1) order by sold desc limit " + a.to_s + ",500;"
          puts "THERE ARE " + res.num_rows.to_s + " ELEMENTS TO UPDATE."
	  count_total = res.num_rows
	    if !res.nil?
              res.each_hash do |row|
              begin	
                count = count + 1
                puts "UPDATING PRODUCT " + count.to_s + " OF " + res.num_rows.to_s
                update_product($agent.get(URI.encode(row["link"])))	
              rescue Exception => ex
    	        puts ex.message + "\n" + ex.backtrace.to_s
              end
              count_total = count_total + 1
            end 
            puts count.to_s + " OF " + count_total.to_s + " PRODUCTS WERE UPDATED" 
       end 
    end
  
end
