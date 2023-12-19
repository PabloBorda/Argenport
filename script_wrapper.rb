
output = "Killer"
count = 30
while output == "Killed" and count <= 30
 IO.popen 'ruby crawler.rb' do |io|
    loop do
      output = io.gets
      break if output.nil? or output.include? "Killed"
    end
  end
  count = count + 1
end


