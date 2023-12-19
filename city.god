God.watch do |w|
  w.name = "City"
  w.dir = "/home/argenport/Argenport"
  w.start = "ruby update_city.rb"
  w.log = "/var/log/updater.log"
  w.keepalive
end
