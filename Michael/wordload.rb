# wordload.rb
require 'rubygems'
require 'engtagger'
require 'mysql2'

# Loads words from database into string with 
# word boundary and pipe added for use as regex.
def loadLibArray()
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>12345, :username=>'root')
	queryResult = client.query("SELECT Word FROM wordbank")
	queryResultArray = queryResult.to_a
	target = Array.new()
	for i in queryResultArray
		
		target << "\\b"+i["Word"]+"\\b"
	end
	return target.join("|")

end

# Uses loaded word list prepared with word boundary
# and pipelines in the form of single string
# to create matching regex pattern.
# Returns regex object that can be used to test
# input sentences for matching to a word library.
def monocle(inputString)
	optic = Regexp.new(inputString)
	return optic
end
	


