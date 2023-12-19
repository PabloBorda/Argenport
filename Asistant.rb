 
# This assistant class is designed to generate investment plans based
# on our money resources, and based on how much should we invest an in what
# to get a constant compensation

module intelligence

  
  
  class Risk
    LOW=0       # Low risk operations - low price products
    MEDIUM=1    # Medium risk operations - neither expensive nor cheap products
    HIGH=2      # High risk operations - high prices products
  end
  
  
  
  class Assistant
  
  
    def initialize
       begin
         # connect to the MySQL server
         @dbh = Mysql.real_connect("localhost", "root", "justice", "crawler")
         # get server version string and display it
         puts "Server version: " + @dbh.get_server_info
       rescue Mysql::Error => e
         puts "Error code: #{e.errno}"
         puts "Error message: #{e.error}"
         puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
       end       
    end
  
  
    
    
    # find the average between maxsoldday and leastsoldday
    # set the time frame to a month from today
    # get the products with maximum sold frequence and lowest price
    # 
    def how_much_do_you_have?(amount,risk)
      
      
    end
    
    
    
    
    
    def how_much_you_want_to_earn_a_month(amount)
      earn_per_day = amount/30
    
      # find products whose average sales per day amount sums earn_per_day
      
      @dbh.query "select * from crawler where 
      
      
      
      
      
    end
                             
  
  
  
  
  
  end



end