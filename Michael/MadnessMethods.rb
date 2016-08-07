# MadnessMaethods.rb
require 'rubygems'
require 'engtagger'

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



