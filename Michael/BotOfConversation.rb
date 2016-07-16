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
		#client = Mysql2::Client.new(:host=>"localhost", :database=>"stuff")
		tgr = EngTagger.new
		text = material
		tagged = tgr.add_tags(text)
		puts tagged
		return tagged

	end
	def export(excrement)
	end
end