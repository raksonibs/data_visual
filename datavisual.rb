require 'open-uri'
require 'nokogiri'

=begin
File.open('weather.txt', 'w') do |f|
	page=Nokogiri::HTML(open("http://www.theweathernetwork.com/weather/canada/ontario/hamilton"))
	#puts page
	weather =page.css("div div div div div div.temperature-area p.condition")
	p weather
	puts weather.text
end
=end
page=Nokogiri::HTML(open("http://www.timeanddate.com/weather/canada/hamilton"))
#puts page
currentweather=page.css("div div table.tbbox tr.d1 table.rpad tr")[1].css("td")[1]
puts currentweather.text
puts page.css("div div table.tbbox tr.d0 table tbody tr.c0")[1].text
