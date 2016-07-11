# BotOfConversation.rb
require 'rubygems'
require 'mysql2'
require 'entagger'
class TalkingBot
	attr-accessor :subject
	def initialize
	end
	def receipt(input)
		input = input.to_s
		processing(input)

	end
	def processing(material)

	end
	def export(excrement)
	end
end