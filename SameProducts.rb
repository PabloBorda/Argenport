require 'MercadoLibre.rb'

class SameProductOrganizer
  
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
  
  def group_similar_products
    products = []
    res = @dbh.query "select id,title,sold from products;"
    while (row = res.fetch_row)
      products.push [row[0],row[1],row[2]]
    end
    products.size.times do |a|
     
      self.title_ocurrences(products[a][title]
    end
      
    end
    
  end
  
  private
  
  
  def title_ocurrences(w1,w2,howequal)

    words_from_title = products[a][1].to_s.split(" ")
      
|   words_from_title.each do |word|
   
  end
  
  
  
end



Mechanize::Util::CODE_DIC[:SJIS] = "ISO-8859-1"
$agent = Mechanize.new { |a| a.log = Logger.new("mech_updater.log") }
$agent.user_agent_alias = "Mac Safari"


ml = MercadoLibre.new
ml.update_all_products
 
 
