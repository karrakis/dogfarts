# BotOfConversation.rb
require 'rubygems'
require 'mysql2'
require 'entagger'
client = Mysql2::Client.new(:host=>"localhost", :database=>"stuff", :password=>)
class TalkingBot
	attr-accessor :subject
	def initialize
	end
	def receipt(input)
		input = input.to_s
		processing(input)

	end
	def processing(material)
		tgr = EngTagger.new
		text = material
		tagged = tgr.add_tags(text)

	end
	def export(excrement)
	end
end