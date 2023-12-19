God.watch do |w|
  w.name = "Updater"
  w.dir = "/home/argenport/Argenport"
  w.start = "ruby updater.rb"
  w.log = "/var/log/updater.log"
  w.keepalive
end

God.watch do |w|
  w.name = "Crawler"
  w.dir = '/home/argenport/Argenport'
  w.start = "ruby crawler.rb"
  w.log = '/var/log/crawler.log'
  w.keepalive
end

God.watch do |w|
  w.name = "City"
  w.dir = '/home/argenport/Argenport'
  w.start = "ruby update_city.rb"
  w.log = '/var/log/city.log'
  w.keepalive
end

