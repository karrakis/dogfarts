require 'engtagger'
require 'mysql2'

class RachelsFartBot

	attr_accessor :subjects

	def initialize

		@client = Mysql2::Client.new(:host => "localhost", :database=>"rachels_dog_farts", :password=>"stinkydogfarts", :username => 'root')
		#define the number of times a subject can be used as the input
		@MAXUSES = 4
		@percent_same_subject = 70
		@percent_ask_question = 70

	end

	def receipt(input)

		input = input.to_s
		processing(input)

	end

	def processing(sentence)

		sentence = cleanup(sentence)
		subjects = tagger(sentence)
		full_question = question(sentence)
		check_input_redundancy(full_question,subjects)
		answer = process_question(full_question)
		export(answer)

	end

	def export(output)

		subjects = tagger(output)
		database_update_output_sentence(output)
		database_update_output_subject(subjects)
		puts(output)

	end

	def cleanup(sentence)

		# Clean up input
		
		sentence.gsub(/([\\\;\"\'\(\)\[\]\{\}\|])+/, "")

	end

	def tagger(sentence)

		# Need to save sentence to database
		# Figure out which parts of speech are which

		tgr = EngTagger.new
		tagged = tgr.add_tags(sentence)

		# Pull all nouns and noun phrases

		wordlist = tgr.get_words(sentence)

		# Divide out the sentences

		sentences = tgr.get_sentences(sentence)

		# Load inputs to database

		database_update_input_subject(wordlist)
		return wordlist

	end

	def question(sentence)

		# Figure out if there is a question and what it is

		tgr = EngTagger.new

		# Figure out question

		sentences = tgr.get_sentences(sentence)

		x = 0

		sentence_info = sentences.map do |sentence|
			hash = {}
			hash["sentence_number"] = x
			x += 1
			hash["sentence"] = sentence
			hash["is_question"] = sentence.include?("\?")

			#figure out if the sentence is complete

			tagged = tgr.add_tags(sentence)
			is_complete = tgr.get_noun_phrases(tagged)
			if is_complete = is_complete.any?
				is_complete = tgr.get_past_tense_verbs(tagged).merge(tgr.get_present_verbs(tagged).merge(tgr.get_infinitive_verbs(tagged).merge(tgr.get_gerund_verbs(tagged))))
				is_complete = is_complete.any?
			end
			hash["is_complete"] = is_complete
			hash
		end

		partial_question = sentence_info.select{|h| h["is_question"] == true}.sort_by{|h| h["sentence_number"]}.last
		sentence_before = sentence_info.select{|h| h["sentence_number"] == partial_question["sentence_number"] - 1}.sort_by{|h| h["sentence_number"]}.last
		if partial_question["is_complete"] == true
			full_question = partial_question["sentence"]
		elsif sentence_before["is_complete"] == true
			full_question = sentence_before["sentence"] + " " + partial_question["sentence"]
		else
			err_handler
		end

		database_update_input_sentence(full_question)
		return full_question
		
	end

	def err_handler(garbled)

		# If err_handler is called, select a random sentence to output

		output = @client.query("SELECT random_sentence FROM random_sentence ORDER BY RAND() LIMIT 1;").to_a.first["random_sentence"]

	end

	def database_update_input_sentence(sentence)

		# Enters input sentence into the database		

		@client.query("INSERT INTO input_sentences (sentence, num_uses) VALUES ('#{sentence}','1') ON DUPLICATE KEY UPDATE num_uses=num_uses+1")
		
	end

	def database_update_input_subject(subject)

		# Enters input subject into the database		

		subject = subject.reject{|k,v| v == 0 }.keys
		subject.each do |sbj|
			@client.query("INSERT INTO input_subjects (subject, num_uses) VALUES ('#{sbj}','1') ON DUPLICATE KEY UPDATE num_uses=num_uses+1")
		end

	end

	def database_update_output_sentence(output)

		# Enters output sentence into the database	

		@client.query("INSERT INTO output_sentences (sentence, num_uses) VALUES ('#{output}','1') ON DUPLICATE KEY UPDATE num_uses=num_uses+1")

	end

	def database_update_output_subject(subject)

		# Enters output subject into the database	

		subject = subject.reject{|k,v| v == 0 }.keys
		subject.each do |sbj|
			@client.query("INSERT INTO output_subjects (subject, num_uses) VALUES ('#{sbj}','1') ON DUPLICATE KEY UPDATE num_uses=num_uses+1")
		end

	end

	def check_input_redundancy(sentence,subject)

		# Checks input sentence and subject to see if they've been used before
		# If input sentence is a repeat, answer as before but angry
		# If subject is getting old, answer the question and then change the subject

		subject = subject.reject{|k,v| v == 0 }.keys
		subject_repeat = 0
		subject.each do |sbj|
			subject_repeat = @client.query("SELECT num_uses FROM input_subjects WHERE subject='#{sbj}'").to_a.first["num_uses"]
			if subject_repeat > @MAXUSES
				break
			end
		end

		sentence_repeat = @client.query("SELECT num_uses FROM input_sentences WHERE sentence='#{sentence}'").to_a.first["num_uses"]
		id = @client.query("SELECT id FROM input_sentences WHERE sentence='#{sentence}'").first["id"]

		if sentence_repeat > 1
			get_angry(id,sentence,sentence_repeat)
			add_something_maybe(sentence,subject)
		elsif subject_repeat > @MAXUSES
			answer_question(sentence,subject)
			change_subject
		else
			answer_question(sentence,subject)
			add_something_maybe(sentence,subject)
		end
	end

	def get_angry(id,sentence,num_uses)

		# Figure out what I said last time this was asked and make the first character lowercase
		query = "SELECT sentence FROM output_sentences WHERE created_at >= (SELECT created_at FROM input_sentences WHERE id ='#{id}') ORDER BY created_at asc limit 1;"
		previous_response = @client.query(query).first['sentence']
		previous_response[0] = previous_response[0].downcase
		
		# Responses depending on the number of times it's been asked

		second_response = ["I already told you: " + previous_response, "Like I said before, " + previous_response, "Just like last time you asked, " + previous_response]
		n_response = ["Dude, I've already answered this " + (num_uses - 1).to_s + " times before, but " + previous_response, "This question is getting really old.  I said: " + previous_response, "Do you actually have a memory? I told you " + previous_response]
		too_many_response = ["I already told you.","Most cats are smarter than you are.  Stop asking me that.", "I'm done."]

		# Choose a response

		if num_uses == 2
			answer = second_response.sample
		elsif (num_uses > 2) && (num_uses < 5)
			answer = n_response.sample
		elsif num_uses > 4
			answer = too_many_response.sample
		else
			err_handler(sentence)
		end

		return answer

	end

	def process_question(question)

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

		qtype = question.match(regex).to_s
		split_question = question.split(regex)

		if qtype == "Who"
			who_question(qtype,split_question)
		elsif qtype == "Where"
			where_question(qtype,split_question)
		elsif qtype == "when"
			when_question(qtype,split_question)
		elsif qtype == "Why"
			why_question(qtype,split_question)
		else
			err_handler(question)
		end
 
	end

	def who_question(qtype,split_question)

		#answer questions about "who" with a person's name

		answer = @client.query("SELECT name FROM people ORDER BY RAND() LIMIT 1;").to_a.first["name"]

	end

	def where_question(qtype,split_question)

		#answer questions about "where" with a place

		answer = @client.query("SELECT name FROM places ORDER BY RAND() LIMIT 1;").to_a.first["name"]

	end

	def why_question(qtype,split_question)

		#answer questions about "why" with a because statement

		answer = @client.query("SELECT name FROM reasons ORDER BY RAND() LIMIT 1;").to_a.first["name"]

	end

	def when_question(qtype,split_question)

		#answer questions about "when," which may be asking about a time or about "when you..."

		if split_question[-1].incude? #need to keep working here
		end

	end

	def add_something_maybe(subject)

		# Sometimes add something after answering the question

		if rand(100) <= @percent_same_subject
			if rand(100) <= @percent_ask_question
				ask_question(subject)
			else
				make_statement(subject)
			end
		else

			new_subject = @client.query("SELECT subject FROM subjects ORDER BY RAND() LIMIT 1;").to_a.first["subject"]

			if rand(100) <= @percent_ask_question
				ask_question(new_subject)
			else
				make_statement(new_subject)
			end
		end

	end

	def ask_question(subject)

		# Ask a question about a given subject

		

	end

end
