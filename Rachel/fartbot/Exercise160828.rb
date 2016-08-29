require 'mysql2'

class Exercise

	def initialize

		@client = Mysql2::Client.new(:host => "localhost", :database=>"rachels_dog_farts", :password=>"stinkydogfarts", :username => 'root')
		#define the number of times a subject can be used as the input
		@MAXUSES = 4

	end

	def main(question)

		regex = turn_to_string
		check_the_thing(regex,question)

	end

	def turn_to_string

		#Turn the question types table into a string for matching purposes

		qtypes = @client.query("SELECT qstart FROM question_types;").to_a
		array = qtypes.map{|m| m["qstart"]}
		string = array.join('\\b|\\b')
		regex = Regexp.new("(?<qstart>\\b#{string}\\b)",Regexp::IGNORECASE)
		return(regex)

	end

	def check_the_thing(regex,question)

		qtype = question.match(regex)
		split_question = question.split(regex)
		#qtype(split_question)

	end

end