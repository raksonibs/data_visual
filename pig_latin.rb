def matchcons(word)
	if word[0].match(/q/i) && word[1].match(/u/i)
		word=word[2,word.size]+word[0...2]
	else
		word=word[1,word.size]+word[0]
	end
	word
end

def customcap(word)
	word[0]=word[0].upcase
	word
end


def translate(words)
	arr=[]
	words.split(" ").map do |word|
		while word.match(/^[^aeiou]/i)
			if word[0][/[A-Z]/]
				word=customcap(matchcons(word))

			else
				word=matchcons(word)
			end
		end
		word=word + "ay" if word.match(/^[aeiou]/i)
		arr << word
	end
	arr.join(" ")

end

