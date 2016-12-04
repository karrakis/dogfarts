# MadnessMaethods.rb
require 'rubygems'
require 'engtagger'
require 'mysql2'
require 'httparty'
require 'nokogiri'

# Mehtod to take in a sentence string from the user.
def intake()
	print "Sentence please =>"
	sentence = gets.chomp
	return sentence
end

# Method to tag the sentence parts of string from user.
def tagSentence(sentenceString)
	# Create tagger object instance
	tagger = EngTagger.new

	# Tag sentence parts
	taggedSentence = tagger.add_tags(sentenceString)

	return taggedSentence
end

# Method to insult user when an improper input has been provided, or when I please.
def insultHumans()
	# Open new connection to database
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>'Th1ngs @nd Stuff', :username=>'root')

	# Get count of insults in database.
	countQuery = client.query("SELECT COUNT(*) as c FROM insults")
	insultCount = countQuery.to_a.first['c']

	# Initiate random instance
	chaos = Random.new

	# Choose a random number within range of insult table Id's
	insultPick = chaos.rand(1..insultCount)

	# Select appropriate insult from sql
	insult = client.query("SELECT insult_text FROM insults where insult_id='#{insultPick}'")

	return insult.to_a.first['insult_text']
	
end


# Checks input text to see if it ends with punctuation.
def endWithPunctuation(inputText)
	inputArray = inputText.split('')
	if inputArray[-1] == "."
		return TRUE 
	elsif inputArray[-1] == "?"
		return TRUE
	elsif inputArray[-1] == "!"
		return TRUE
	else
		return FALSE
	end	

	# return inputArray
end

# Feed a sentence, prefferably an insulting one, to add it to the insults database.
def addInsult()
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>'Th1ngs @nd Stuff', :username=>'root')

	# Grab insult from user.
	insultText = gets.chomp
	
	# Modify text for sql insertion.
	escaped = client.escape(insultText)

	

	client.query("INSERT INTO insults (insult_text) VALUES ('#{escaped}')")
	puts "Insult added to database. \nThank you for making the world a better worse place."
end

# Feed this method a tagged sentence to see if if contains nouns.
def containsNoun(sentence)
	if sentence.include? "<nn"
		return TRUE
	else
		return FALSE
	end
end


# Feed this method a tagged sentence to see if it contains verbs.
def containsVerb(sentence)
	if sentence.include? "<v"
		return TRUE
	else
		return FALSE
	end
end

# Feed a sentence to find out if it's a question.
def isQuestion(sentence)
	if sentence.include? "?"
		return TRUE
	else
		FALSE
	end
end

# Input an untagged question sentence to find out whether bot
# should supply definition type response.

def defQuestion(sentence)
	sentence = sentence.downcase
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>'Th1ngs @nd Stuff', :username=>'root')
	queryResult = client.query("SELECT word FROM defQuestionWords")
	queryResultArray = queryResult
	target = Array.new()
	for i in queryResultArray
		
		target << "\\b"+i["word"]+"\\b"
	end
	optic = Regexp.new(target.join("|"))
	# TODO run match against optic.
	
	if (optic =~ (sentence)) then
		return true

	else
		return false

		
	end
	client.close()
end

def personQuestionAnswer(sentence)
	sentence = sentence.downcase
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>'Th1ngs @nd Stuff', :username=>'root')
	queryResult = client.query("SELECT word FROM personQuestionWords")
	queryResultArray = queryResult
	
	# create array from query result
	target = Array.new()
	
	# populate array with pipe delimited data from query.
	for i in queryResultArray
		
		target << "\\b"+i["word"]+"\\b"
	end
	
	# create regex filter looking for words in sentence, non-exclusive or.
	optic = Regexp.new(target.join("|"))
	# run match against optic.
	
	if (optic =~ (sentence)) then
		return true

	else
		return false

		
	end
	client.close()
end	



# Stashes unhandled untagged sentence for later analysis
def stashForAnalysis(sentence)
	
	# Open connection object to sql
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>'Th1ngs @nd Stuff', :username=>'root')

	# Place sentence into variable that mysql2 can handle.
	escaped = client.escape(sentence)

	# Insert sentence into analysis database.
	client.query("INSERT INTO AnalyzeSentence (Sentence) VALUES ('#{escaped}')")

end


# Send API call to merriam webster and retrieve definition for supplied word.
def defQuestionAnswer(wordToDefine)
	
	word = wordToDefine

	

	request = HTTParty.get("http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{word}?key=e1370b7d-69b3-468e-a867-5b876ead2bf3")

	doc = Nokogiri::XML(request.body)

	defArray = doc.xpath("//dt/text()").to_a
	
	
	

	return defArray[0]
end


# Returns random male or female name from table.
def returnPerson()
	# Open connection object to sql
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>'Th1ngs @nd Stuff', :username=>'root')

	# Get count of all the name entries in the database.
	nameCount = client.query('SELECT COUNT(Name) FROM chatbot.People').to_a.first

	# Get number for id count 
	idNum = nameCount["COUNT(Name)"]

	# SELECT random number from range of names in datbase.
	id = rand(1..idNum)

	# Return name associated with random number choice from database.
	queryResult = client.query("SELECT Name FROM chatbot.People WHERE ID = '#{id}'").to_a.first

	randomName = queryResult["Name"].downcase.capitalize

	client.close()

	return randomName
end

def supplyTime()
	currentTime = Time.now

	timeStatement = "The time is " + currentTime.inspect

	puts timeStatement

end
