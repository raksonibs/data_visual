
require 'open-uri'
require 'nokogiri'
require 'gchart'
page=Nokogiri::HTML(open("http://www.theweathernetwork.com/hourly-weather-forecast/canada/ontario/hamilton"))
	#puts page


currentweather=page.css("div.weather-forecast div.bx-wrapper") #div.bx-window div#weather-forecast.forecast-carousel.carousel")

puts currentweather