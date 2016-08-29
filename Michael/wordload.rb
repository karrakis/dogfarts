# wordload.rb
require 'rubygems'
require 'engtagger'
require 'mysql2'


def loadLibArray()
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>12345, :username=>'root')
	queryResult = client.query("SELECT Word FROM wordbank")
	queryResultArray = queryResult.to_a
	target = Array.new()
	for i in queryResultArray
		target << i["Word"]
	end
	return target.join(" ")

end