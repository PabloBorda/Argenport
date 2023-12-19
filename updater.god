God.watch do |w|
  w.name = "Updater"
  w.dir = "/home/argenport/Argenport"
  w.start = "ruby updater.rb"
  w.log = "/var/log/updater.log"
  w.keepalive
end
