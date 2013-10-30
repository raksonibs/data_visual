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

#create css file also to get based on current description, cloudy, sunny, rainy, a new image.
#want to make the css background image change depending on the temperature range
File.open('weather.html', 'w') do |f|

	f.write("<!DOCTYPE html>\n<html>\n<head>\n<title> Weather Deconstructed </title>\n<link rel= \"stylesheet\" href=\"stylesheetweather1.css\">\n</head>\n<body>\n<script src=\"javascriptweather.js\"></script>\n<header>\n<h1> Weather for Hamilton, Ontario </h1>\n<hr>\n</header>\n<div>\n")
	page=Nokogiri::HTML(open("http://www.timeanddate.com/weather/canada/hamilton"))
	#puts page


	currentweather=page.css("div div table.tbbox tr.d1 table.rpad tr")[1].css("td")[1].text


	currentweatherdesc=page.css("div div table.tbbox tr.d1 td#we1 h4").text.split(".")[0]


	time=page.css("div div table.tbbox tr.d0 thead tr.c1")[1].text
	futureweather=page.css("div div table.tbbox tr.d0 table tbody tr.c0")[1].text
	currentweather=currentweather.scan(/\d+/)
	
	f.write("<h2> Today's temperature: "+currentweather[0]+" Celsuis"+ " Description: <em class=\"head\">"+ currentweatherdesc + "</em></h2>\n")
	time=time.scan(/[A-Z][a-z]+/)
	futuredescriptions=page.css("div div table.tbbox tr.d0 table tbody tr.c1")[0].text
	#refactor to go through loop to gsub each value)
	val=futuredescriptions.gsub("Description:", "").gsub("Cool.","").gsub("Chilly.","").split("\.")
	val=val[0..time.length-1]
	conditions=time.zip(val)
	timedates=page.css("div div table.tbbox tr.d0 thead tr.c1")[0].text
	timedates=timedates.scan(/[A-Z][a-z]+/)
	
	index=0

	futureweather=futureweather.scan(/\d+/)
	combinedtimeandweather=time.zip(futureweather)
	currentconditions=val.zip(combinedtimeandweather)
	currentconditions.each do |i|
		index+=1 if i.flatten[1]=="Night"

		f.write("<p>"+"<strong>"+timedates[index]+" "+i.flatten[1]+"</strong>"+" temperature: "+i.flatten[2]+" Celsius" + " Description: <em>"+ i.flatten[0]+ "</em></p>\n")
	end

	File.open("stylesheetweather1.css", "w") do |c|
		pic="clouds.jpg" if currentweatherdesc.match(/cloudy/i)
		pic="passingclouds.jpg" if currentweatherdesc.match(/scattered|broken|passing/i)
		pic="rain.jpg" if currentweatherdesc.match(/rain/i) || currentweatherdesc.match(/shower/i)
		c.write("html {\n background: url(#{pic}) no-repeat center center fixed;\n-webkit-background-size: cover;\n-moz-background-size: cover;\n-o-background-size: cover;\nbackground-size: cover;\n}\n\n* {\ncolor: #660099;\nfont-size: 25px;\n} \nh2,\nem.head {\n font-size:46px;\n}\nfooter p,\nfooter a{\ncolor: red;\n}\ndiv p {\n margin: auto;\ntext-align:center;\nopacity:0.4;\nfilter:alpha(opacity=40);\n}\ndiv p:hover {\nopacity:1.0;\nfilter:alpha(opacity=100);\n}\ndiv p:nth-child(even) {\ncolor:white;\nbackground-color:black;\n}\ndiv p:nth-child(odd) {\ncolor:black;\nbackground-color:white;\n}")
	end

=begin
	combinedtimeandweather.each do |i|

		f.write("<p>"+i[0]+" temperature: "+i[1]+" Celsius</p>\n")
	end

	conditions.each do |i|
		f.write("<p>"+i[0]+" temperature: "+i[1]+" Celsius</p>\n")
	end
=end
	f.write("</div>\n<footer>\n<hr>\n<p> Contact me if you are interested in weather </p>\n<p> 905-575-5111 </p>\n<p> skype: oskarniburski </p>\n<a href=\"mailto:oskarniburski@gmail.com\">oskarniburski@gmail.com</a>\n</footer>\n</body>\n</html>")
end

