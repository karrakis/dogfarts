guessdog = [rand(1-255), rand(1-255), rand(1-255)]

actualdog = ["d".ord, "o".ord, "g".ord]

puts("Caution: this script may require literally trillions of calculations to complete!")

puts("Now attempting to guess the first word in the string!")

while guessdog != actualdog
	guessdog = [rand(1-255), rand(1-255), rand(1-255)]
end

guessdogtext = guessdog.pack("c*")

puts("The first word in the string is " + guessdogtext + "!")



guessfarts = [rand(1-255), rand(1-255), rand(1-255), rand(1-255), rand(1-255)]

actualfarts = ["f".ord, "a".ord, "r".ord, "t".ord, "s".ord]

puts("Now attempting to guess the second word in the string!")

while guessfarts != actualfarts
	guessfarts = [rand(1-255), rand(1-255), rand(1-255), rand(1-255), rand(1-255)]
end

guessfartstext = guessfarts.pack("c*")

puts("The second word in the string is " + guessfartstext + "!")

p(guessdogtext + " " + guessfartstext)