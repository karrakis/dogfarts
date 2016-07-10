puts "What is your dog's name?"

yourdog = gets

yourdog.chomp!
yourdog.downcase!

while (yourdog != "harley")
	puts "That's not your dog!  What is your dog's name?"

	yourdog = gets

	yourdog.chomp!
	yourdog.downcase!

end

puts "What is Liz's dog's name?"

lizdog = gets

lizdog.chomp!
lizdog.downcase!

while (lizdog != "wald")
	puts "That's not your dog!  What is your dog's name?"

	lizdog = gets

	lizdog.chomp!
	lizdog.downcase!

end

String.try_convert(yourdog) # yeah, I know these are already strings...but unnecessary complication!
String.try_convert(lizdog)

puts("The fact is that Harley is a dog.  Changing \"#{yourdog}\" to \"dog\"")
yourdog.sub! 'harley', 'dog'

puts("The fact is that Wald NEVER stops farting.  Changing \"#{lizdog}\" to \"farts\"")
lizdog.sub! 'wald', 'farts'

p(yourdog + " " + lizdog)