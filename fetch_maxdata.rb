require 'mechanize'
require 'debugger'

mechanize = Mechanize.new

page = mechanize.get('http://admin.rankedgaming.com')

form = page.forms.first

print "Enter rgc username: "
username = gets.chomp
form['user'] = username

print "Enter rgc password: "
password = gets.chomp
form['pass'] = password

page = mechanize.submit(form)

print "Enter a rgc username to fetch details for: "
rgcname = gets.chomp

result_page = mechanize.get("http://admin.rankedgaming.com/local/gamelogs/search.php?d=1&m=0&var=#{rgcname}")

link_number = 2

kills = []
deaths = []
assists = []

loop do
  link = result_page.link_with(:text=> link_number.to_s)
  link_number = link_number + 1
  puts "Extracting page #{link_number - 2} data"
  result_page.parser.css('.table .row').each do |match|
    kills << match.css('.cell')[7].text.to_s
    deaths << match.css('.cell')[8].text.to_s
    assists << match.css('.cell')[9].text.to_s
  end
  break unless link
  result_page = link.click
end

kills = kills.map(&:to_i)
deaths = deaths.map(&:to_i)
assists = assists.map(&:to_i)

puts "Fetching data for #{rgcname}:"
puts "Maximum kills : #{kills.max}"
puts "Maximum Deaths : #{deaths.max}"
puts "Maximum Assists : #{assists.max}"
