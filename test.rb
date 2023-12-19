require 'test/unit'
require 'rubygems'
require 'mechanize'
require 'Crawler.rb'
require 'MercadoLibre.rb'
require 'Product.rb'
require 'hpricot'
 
class MiPrimerTest < Test::Unit::TestCase
  
  def set_up
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
    pr = Product.new @dbh,"http://articulo.mercadolibre.com.ar/MLA-125254470-schnauzer-mini-excelentes-cachorros-con-papeles-de-fca-_JM"
    @agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
    @agent.user_agent_alias = "Mac Safari"
  end
  
  def test_get_product_data
    @ml = MercadoLibre.new
    @agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
    @agent.user_agent_alias = "Mac Safari"
    prstr = @ml.get_product_from_page(@agent.get("http://articulo.mercadolibre.com.ar/MLA-125254470-schnauzer-mini-excelentes-cachorros-con-papeles-de-fca-_JM"))
    
    prstr.print

  end

  def test_is_a_product
    @ml = MercadoLibre.new
    @agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
    @agent.user_agent_alias = "Mac Safari"
    assert_equal @ml.is_a_product?(@agent.get("http://articulo.mercadolibre.com.ar/MLA-125254470-schnauzer-mini-excelentes-cachorros-con-papeles-de-fca-_JM")),false
    assert_equal @ml.is_a_product?(@agent.get("http://articulo.mercadolibre.com.ar/MLA-122630059-cardio-twister-ejercitador-de-piernas-y-abdominales-tonifica-_JM")),true
    assert_equal @ml.is_a_product?(@agent.get("http://computacion.mercadolibre.com.ar/apple-notebooks/")),false
    assert_equal @ml.is_a_product?(@agent.get("http://listado.mercadolibre.com.ar/perros/")), false
    assert_equal @ml.is_a_product?(@agent.get("http://inmueble.mercadolibre.com.ar/MLA-122728168-quiosco-de-diarios-y-revistas-en-av-rivadavia-_JM")),true
  end
  
  
  def test_was_visited
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
    
    @agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
    @agent.user_agent_alias = "Mac Safari"
    @ml = MercadoLibre.new
    assert_equal (@ml.was_visited "http://listado.mercadolibre.com.ar/yeguas/"), true
    
  end
  
  
  def test_link_filter
    @ml = MercadoLibre.new
    assert_equal(@ml.filter_links("http://listado.mercadolibre.co.cr/_CategID_1898"),true)
  end
  
  
  
  def test_update_product 
    assert true
  end
end
