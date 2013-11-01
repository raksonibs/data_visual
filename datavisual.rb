require 'open-uri'
require 'nokogiri'
require 'gchart'

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
#change to farenheit? Fun facts about hamilton
File.open('weather.html', 'w') do |f|

	f.write("<!DOCTYPE html>\n<html>\n<head>\n<title> Weather Deconstructed </title>\n<link rel= \"stylesheet\" href=\"stylesheetweather1.css\">\n</head>\n<body>\n<script src=\"javascriptweather.js\"></script>\n<header>\n<h1> Weather for Hamilton, Ontario </h1>\n</header>\n<div>\n<hr>\n")
	page=Nokogiri::HTML(open("http://www.timeanddate.com/weather/canada/hamilton"))
	#puts page


	currentweather=page.css("div div table.tbbox tr.d1 table.rpad tr")[1].css("td")[1].text


	currentweatherdesc=page.css("div div table.tbbox tr.d1 td#we1 h4").text.split(".")[0]


	time=page.css("div div table.tbbox tr.d0 thead tr.c1")[1].text
	futureweather=page.css("div div table.tbbox tr.d0 table tbody tr.c0")[1].text
	currentweather=currentweather.scan(/\d+/)
	p currentweather
	
	f.write("<h2> Today's temperature: "+currentweather[0]+" Celsius</h2>")
	f.write("<h2>Conditions: <em class=\"head\">"+ currentweatherdesc + "</em></h2>\n")
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
	data1=currentweather+futureweather
	data=(currentweather+futureweather).map {|i| i.to_i}
	if time[0]=="Evening"
		now="Afternoon"
	elsif time[0]=="Night"
		now="Evening"
	elsif time[0]=="Night"
		now="Morning"
	elsif time[0]=="Morning"
		now="Night"
	end
	timevals=time.unshift(now)



	chart=Gchart.line(:title => "Temperature over the next few hours", 
					  :title_size=> 23, 
					  :title_color=> 'FF0000',
					  :data =>[data],
					  :size => '500x350',
					  :axis_with_labels => 'r,x,y',
					  :axis_labels => [[0],timevals,data.sort])
	currentconditions.each do |i|
		index+=1 if i.flatten[1]=="Night"


		f.write("<p>"+"<strong>"+timedates[index]+" "+i.flatten[1]+"</strong>"+" temperature: "+i.flatten[2]+" Celsius" + " Description: <em>"+ i.flatten[0]+ "</em></p>\n")
	end




=begin
	combinedtimeandweather.each do |i|

		f.write("<p>"+i[0]+" temperature: "+i[1]+" Celsius</p>\n")
	end

	conditions.each do |i|
		f.write("<p>"+i[0]+" temperature: "+i[1]+" Celsius</p>\n")
	end
=end
	f.write("\n</div>\n<div class= \"graph\">\n<img class=\"chart\"src=#{chart}>\n<img class =\"weatherpic\" title=\"Hamilton Right Now\" src=\"http://www.cdn.mto.gov.on.ca/english/traveller/compass/camera/pictures/BurlCamera/loc04.jpg\">\n</div>\n<footer>\n<hr>\n<p> Contact me if you are interested in weather </p>\n<p> 905-575-5111 </p>\n<p> skype: oskarniburski </p>\n<a href=\"mailto:oskarniburski@gmail.com\">oskarniburski@gmail.com</a>\n</footer>\n</body>\n</html>")
	File.open("stylesheetweather1.css", "w") do |c|

		pic="clouds.jpg" if currentweatherdesc.match(/cloudy/i)
		pic="passingclouds.jpg" if currentweatherdesc.match(/scattered|broken|passing/i)
		pic="rain.jpg" if currentweatherdesc.match(/rain/i) || currentweatherdesc.match(/shower/i)
		pic="sunny.jpg" if currentweatherdesc.match(/sun/i) && !currentweatherdesc.match(/cloud/i)
		pic="fog.jpg" if currentweatherdesc.match(/fog/i)
		pic="sprinkles.jpg" if currentweatherdesc.match(/sprinkles/i)

		c.write("html {\n background: url(#{pic}) no-repeat center center fixed;\n-webkit-background-size: cover;\n-moz-background-size: cover;\n-o-background-size: cover;\nbackground-size: cover;\n}div {\nmargin: auto;\n}\n.graph {\nbackground-color: rgba(120,32,32,0.5);\nborder: 1px solid black;\n}\nimg.chart {\nmargin:auto;\ndisplay:inline;\n}\n* {\ncolor: #660099;\nfont-size: 25px;\n} \nh2,\nem.head {\n font-size:46px;\nline-height:10%;\n}\nfooter p,\nfooter a,\na{\ncolor: red;\nline-height:10%;\n}\ndiv p {\n margin: auto;\ntext-align:center;\nopacity:0.4;\nfilter:alpha(opacity=40);\nborder-radius:4%;\nwidth: 60vw;\n}\ndiv p:hover {\nopacity:1.0;\nfilter:alpha(opacity=100);\n}\ndiv p:nth-child(even) {\ncolor:white;\nbackground-color:black;\n}\ndiv p:nth-child(odd) {\ncolor:black;\nbackground-color:white;\n}\ndiv:not(.graph) {\nbackground-color: rgba(276,34,54,0.5);\nborder-radius: 5%;\nwidth:80vw;\n}\nimg.weatherpic {\nwidth:500px;\nheight:380px\ndisplay:inline;\n}")
	end
end

