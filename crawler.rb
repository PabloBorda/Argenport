#!/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'mechanize'
require 'logger'
require 'mysql'
require 'Crawler.rb'
require 'MercadoLibre.rb'
require 'Product.rb'

Mechanize::Util::CODE_DIC[:SJIS] = "ISO-8859-1"
$agent = Mechanize.new
$agent.user_agent_alias = "Windows Mozilla"
$dont_follow = ["Registrate","Ingresar","Mi Cuenta","Ayuda","Vender","Autos, Motos y Otros","Inmuebles","Servicios","Ver todas","Ver más","Banco Provincia","Standard Bank","Banco Hipotecario","Más bancos","Ver más","Movistar Chat de Movistar","Mapa del Sitio","Investor Relations","Ver otros países","MercadoPago","MercadoClics","MercadoShops","Términos y Condiciones","Políticas de Privacidad","Facebook","Twitter","Políticas de Privacidad","Términos y Condiciones","Protección al Comprador","Centro de Seguridad","Sobre MercadoLibre","Hacer una pregunta","Ver calificaciones","Ver promociones","Ver condiciones","Más opciones","Seguir esta publicación","Denunciar","Mapa del Sitio"]




ml = MercadoLibre.new
ml.crawl
