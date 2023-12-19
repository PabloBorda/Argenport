 require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'mechanize'
require 'logger'
require 'mysql' 


class Sale

  attr_accessor :id
  attr_accessor :when
  attr_accessor :amount
  attr_accessor :product

  def initialize(*args)
    if args.size == 0
      @id = 0
      @when = ""
      @amount = 0
      @product = 0
    else   
      productid = args[1]
      db = args[0]
      res = db.query "select * from sales where id = '" + productid.to_s + "';"
      while row = res.fetch_row do
        row[0], row[1],row[2],row[3]
      end
      hash = res.fetch_hash
      if !hash.nil?
	@id = hash["id"]
        @when = hash["when"]
        @amount = hash["amount"]
        @sold = hash["sold"]
        @maxsoldday = hash["maxsoldday"]
        @leastsoldday = hash["leastsoldday"]
        @updated = hash["updated"]
        @localcost = hash["localcost"]
        @chinacost = hash["chinacost"]
        @maxsolddate = hash["maxsolddate"]
        @minsolddate = hash["minsolddate"]
        @currency = hash["currency"]
      end
    end

  end


  def print
    puts "**** Product Id: " + @id.to_s
    puts "**** Title: " + @title.to_s
    puts "**** Price: " + @currency.to_s + " " + @localcost.to_s 
    puts "**** Sold: " + @sold.to_s
    puts "**** Max Sales: " + @maxsoldday.to_s + " Date " + @maxsolddate.to_s
    puts "**** Min Sales: " + @leastsoldday.to_s + " Date " + @minsolddate.to_s
    puts "**** Link: " + @link.to_s
    puts "**** Updated: " + @updated.to_s
  end

end

