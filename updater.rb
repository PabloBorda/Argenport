require './MercadoLibre.rb'

Mechanize::Util::CODE_DIC[:SJIS] = "ISO-8859-1"
$agent = Mechanize.new
$agent.user_agent_alias = "Mac Safari"


ml = MercadoLibre.new
ml.update_all_products
 
