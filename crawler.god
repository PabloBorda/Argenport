God.watch do |w|
  w.name = "Crawler"
  w.dir = '/home/argenport/Argenport'
  w.start = "ruby crawler.rb"
  w.log = '/var/log/crawler.log'
  w.keepalive
end

