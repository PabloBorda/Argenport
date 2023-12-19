require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'mechanize'
require 'logger'
require 'mysql' 


class Product

  attr_accessor :id
  attr_accessor :title
  attr_accessor :link
  attr_accessor :sold
  attr_accessor :updated
  attr_accessor :localcost
  attr_accessor :chinacost
  attr_accessor :currency
  attr_accessor :channel
  attr_accessor :db
  

  def initialize(*args)
    if args.size == 0
      @id = "0"
      @title = ""
      @link = ""
      @sold = "0"
      @updated = "01/01/2000"
      @localcost = "0"
      @chinacost = "0"
      @currency = "$"
      @channel = ""
    else   
      link = args[1]
      @db = args[0]
      res = @db.query "select * from products where link = '" + link.to_s + "';"
      if res.num_rows == 0 or res.nil?
        puts "NO PRODUCT WITH URL : " + link.to_s + " FOUND."
        @id = "-1"
        @title = ""
        @link = ""
        @sold = "0"
        @updated = "01/01/2000"
        @localcost = "0"
        @chinacost = "0"
        @currency = "$"
        @channel = ""
      else
        hash = res.fetch_hash
        if !hash.nil?
          @id = hash["id"]
          @title = hash["title"]
          @link = hash["link"]
          @sold = hash["sold"]
          @updated = hash["updated"]
          @localcost = hash["localcost"]
          @chinacost = hash["chinacost"]
          @currency = hash["currency"]
	  @channel = hash["channel"]
        end
      end
    end

  end


  def print
    
    puts "**** Product Id: " + @id.to_s
    puts "**** Title: " + @title.to_s
    puts "**** Price: " + @currency.to_s + " " + @localcost.to_s 
    puts "**** Sold: " + @sold.to_s
    if !@id.to_s.eql? "0" and !@id.to_s.eql? "-1"
      puts "select * from sales where (product=" + @id.to_s + ");"
      res = @db.query "select * from sales where (product=" + @id.to_s + ") order by amount limit 10;"
    
      while row = res.fetch_row do
       puts "The day" +  row[1].to_s + ", " + row[2].to_s + "products were sold."
      end
    end
    puts "**** Channel: " + @channel.to_s
    puts "**** Link: " + @link.to_s
    puts "**** Updated: " + @updated.to_s
  end

end

