# MadnessMaethods.rb
require 'rubygems'
require 'engtagger'
require 'mysql2'

# Mehtod to take in a sentence string from the user.
def intake
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
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>12345, :username=>'root')

	# Get count of insults in database.
	countQuery = client.query("SELECT COUNT(*) as c FROM insults")
	insultCount = countQuery.to_a.first['c']

	# Initiate random instance
	chaos = Random.new

	# Choose a random number within range of insult table Id's
	insultPick = chaos.rand(1..insultCount)

	# Select appropriate insult from sql
	insult = client.query("SELECT insult_text FROM insults where insult_id='#{insultPick}'")

	p insult.to_a.first['insult_text']



	

	

	
end




