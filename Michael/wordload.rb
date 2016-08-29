# wordload.rb
require 'rubygems'
require 'engtagger'
require 'mysql2'


def loadLibArray()
	client = Mysql2::Client.new(:host=>"localhost", :database=>"chatbot", :password=>12345, :username=>'root')
	client.query("SELECT Word FROM wordbank")
end