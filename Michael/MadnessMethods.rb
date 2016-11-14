# MadnessMaethods.rb
require 'rubygems'
require 'engtagger'
require 'mysql2'

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

	

	client.query("INSERT INTO Insults (insult_text) VALUES ('#{escaped}')")
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
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>'Th1ngs @nd Stuff', :username=>'root')
	queryResult = client.query("SELECT word FROM defQuestionWords")
	queryResultArray = queryResult
	target = Array.new()
	for i in queryResultArray
		
		target << "\\b"+i["word"]+"\\b"
	end
	optic = Regexp.new(target.join("|"))
	# TODO run match against optic.
end







