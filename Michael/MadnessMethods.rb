# MadnessMaethods.rb
require 'rubygems'
require 'engtagger'
require 'mysql2'

def intake
	print "Sentence please =>"
	sentence = gets.chomp
	return sentence
end


def tagSentence(sentenceString)
	# Create tagger object instance
	tagger = EngTagger.new

	# Tag sentence parts
	taggedSentence = tagger.add_tags(sentenceString)

	return taggedSentence
end

def insultHumans()
	# Open new connection to database
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>12345, :username=>'root')

	# Get count of insults in database.
	count = client.query("SELECT * FROM insults;")

	client.close

	print count
end




