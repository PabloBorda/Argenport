require 'rubygems'
require 'mechanize'
require './MercadoLibre.rb'


 def parse_city_from(p)
    p.parser.xpath("/html/body/div[4]/div[2]/dl[2]/dd[2]/strong[1]/text()").to_s
 
  end

  def is_a_product?(page)
    return ((page.uri.to_s.include? "articulo.") and (page.parser.xpath("/html/body/div[4]/div[2]/dl[1]/dd/strong").to_s.include? "price principal") and (page.parser.xpath("/html/body/div[2]/p/span").to_s.include? "Publicaci贸n #"))
  end 


 Mechanize::Util::CODE_DIC[:SJIS] = "ISO-8859-1"
    $agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
    $agent.user_agent_alias = "Mac Safari" 

 page = $agent.get(URI.encode("http://articulo.mercadolibre.com.co/MCO-403394627-sony-nueva-psp-go-16-gb-negra-entrega-inmediata-programable-_JM")) 
 puts parse_city_from(page)
