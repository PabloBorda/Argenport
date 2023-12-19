require 'rubygems'
require 'mechanize'

require './MercadoLibre.rb'


  def parse_city_from(p)
    p.parser.xpath("/html/body/div[4]/div[2]/dl[2]/dd[2]/strong[1]/text()").to_s.delete('\'').to_s
 
  end

  def is_a_product?(page) 
    return ((page.uri.to_s.include? "articulo.") and (page.parser.xpath("/html/body/div[4]/div[2]/dl[1]/dd/strong").to_s.include? "price principal") and (page.parser.xpath("/html/body/div[2]/p/span").to_s.include? "Publicación"))
  end 


  def update_city_from_product

    Mechanize::Util::CODE_DIC[:SJIS] = "ISO-8859-1"


    $agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
    $agent.user_agent_alias = "Mac Safari"
    $agent.keep_alive = false
    res = @dbh.query "select * from products order by updated desc;"   
    count = 0
    while row = res.fetch_row do
      page = $agent.get(row[2])
      if is_a_product? page      
	city = parse_city_from page
 q1 = "update products set city=\'" + city.to_s + "\' where products.id=" + row[0].to_s + ";"
     puts "Executing " + q1.to_s
  @dbh.query q1

   end
end

end


 
@dbh = Mysql.real_connect("localhost","root","justice","crawler")
update_city_from_product

  
  
