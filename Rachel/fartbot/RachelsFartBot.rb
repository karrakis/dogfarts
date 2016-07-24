require "engtagger"

class RachelsFartBot

	attr_accessor :subjects

	def initialize

	end

	def receipt(input)

		input = input.to_s
		processing(input)

	end

	def processing(sentence)

		p(sentence)
		sentence = cleanup(sentence)
		p(sentence)
		tagger(sentence)
		export(sentence)

	end

	def export(output)

		puts(output)

	end

	def cleanup(sentence)

		# Clean up input
		
		p(sentence)
		sentence.gsub(/([\\\;\"\'\(\)\[\]\{\}\|])+/, "")

	end

	def tagger(sentence)

		# Need to save sentence to database
		# Figure out which parts of speech are which

		tgr = EngTagger.new
		tagged = tgr.add_tags(sentence)
		p(tagged)

		# Pull all nouns and noun phrases
		# Need to save to database

		wordlist = tgr.get_words(sentence)
		p(wordlist)

		# Divide out the sentences

		sentences = tgr.get_sentences(sentence)

	end

	def question(sentence)

		# Figure out if there is a question and what it is

		tgr = EngTagger.new

		#Figure out question

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
		p(partial_question)
		sentence_before = sentence_info.select{|h| h["sentence_number"] == partial_question["sentence_number"] - 1}.sort_by{|h| h["sentence_number"]}.last
		p(sentence_before)
		if partial_question["is_complete"] == true
			full_question = partial_question["sentence"]
		elsif sentence_before["is_complete"] == true
			full_question = sentence_before["sentence"] + " " + partial_question["sentence"]
		else
			err_handler
		end

		return full_question
		
	end

	def err_handler()
	end

end