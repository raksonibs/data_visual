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
File.open('weather.html', 'w') do |f|
	f.write("<!DOCTYPE html>\n<head>\n<title> Weather Deconstructed </title>\n<link rel= \"stylesheet\" href=\"stylesheetweather.css\">\n</head>\n<body>\n<header>\n<h1> Weather for Hamilton, Ontario </h1>\n<hr>\n</header>\n<div>\n")
	page=Nokogiri::HTML(open("http://www.timeanddate.com/weather/canada/hamilton"))
	#puts page
	currentweather=page.css("div div table.tbbox tr.d1 table.rpad tr")[1].css("td")[1].text
	time=page.css("div div table.tbbox tr.d0 thead tr.c1")[1].text
	futureweather=page.css("div div table.tbbox tr.d0 table tbody tr.c0")[1].text
	f.write("<p> Today's temperature: "+currentweather[0]+" Celsuis"+"</p>\n")
	time=time.scan(/[A-Z][a-z]+/)

	futureweather=futureweather.scan(/\d+/)
	combinedtimeandweather=time.zip(futureweather)

	combinedtimeandweather.each_with_index do |i|
		f.write("<p>"+i[0]+" temperature: "+i[1]+" Celsius</p>\n")
	end
	f.write("</div>\n<footer>\n<hr>\n<p> Contact me if you are interested in weather </p>\n<p> 905-575-5111 </p>\n<p> skype: oskarniburski </p>\n<a href=\"mailto:oskarniburski@gmail.com\">oskarniburski@gmail.com</a>\n</footer>\n</body>\n")
end


