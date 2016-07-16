# BotOfConversation.rb
require 'rubygems'
require 'mysql2'
require 'engtagger'
class TalkingBot
	#attr-accessor :subject
	def initialize
	end
	def receipt(input)
		input = input.to_s
		processing(input)

	end
	def processing(material)
		# open connection to database.
		client = Mysql2::Client.new(:host=>"localhost", :database=>"stuff", :password=>12345, :username=>'root')
		
		# create tagged string from input
		tgr = EngTagger.new
		text = material
		tagged = tgr.add_tags(text)

		taggedArr = tagged.split(" ")
		
		# Testing debug statements, remove in prod.
		puts tagged
		puts taggedArr
		
		# close database connection for good measure.
		client.close
		
		# return result, mostly for debugging.
		return tagged


	end
	def export(excrement)
	end
end