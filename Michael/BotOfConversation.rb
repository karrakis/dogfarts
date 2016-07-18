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
		# open connection to database. If in prod, change creds to pull from file.
		client = Mysql2::Client.new(:host=>"localhost", :database=>"stuff", :password=>12345, :username=>'root')
		
		# create tagged string from input
		tgr = EngTagger.new
		text = material
		tagged = tgr.add_tags(text)

		taggedArr = tagged.split(" ")
		
		#Insert words from string into database
		# according to its tag designation.
		for item in taggedArr
			time = Time.new
			tag = item[/\<.*?\>/]
			word = item[/(?<=\>).*?(?=\<)/]
			case tag
			when "<pp>"
				client.query("INSERT INTO punctuation_end (word,last_used) VALUES (#{@word}, #{@time}")


			p tag
			p word
		end
		
		# Testing debug statements, remove in prod.
		# p tagged
		# p taggedArr
		
		# close database connection for good measure.
		client.close
		
		# return result, mostly for debugging.
		return tagged


	end
	def export(excrement)
	end
end