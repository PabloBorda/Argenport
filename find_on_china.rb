require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'mechanize'
require 'logger'
require 'mysql'
require 'Product.rb'




class ChinaFinder
  
  def initialize(product_title)
    @keyword1 = ""
    @keyword2 = ""
    
    @keywords = ((product_title.split "-")[0].split " ")
    
    @keywords.each {
      |a|
      if a.length > @keyword1.length
        @keyword1 = a        
      end
      }
    @keywords.delete @keyword1
    @keywords.each{
      |a|
      if a.length > @keyword2.length
        @keyword2 = a        
      end
    }
    
    puts "K1 " + @keyword1
    puts "K2 " + @keyword2
    
    
  end
  
  
  
  
  def dhgate
    page = ($agent.get "http://www.dhgate.com/")
    frm = page.forms.first
    frm["searchkey"] = @keyword2
    puts frm.submit.links.to_s
    
  end
  
  
  
  
  
  
end



$agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
$agent.user_agent_alias = "Mac Safari"

cf = ChinaFinder.new("Nanodot Neocube Bucky Balls Imanes Para Crear Jugar. Niquel - $ 189,99 en MercadoLibre")
cf.dhgate

