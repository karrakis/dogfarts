# evenFibNums.rb

def fibs()
	x=0
	y=1
	allFibs = Array.new()
	while y<4000000 do
		temp = y
		y=y+x
		x=temp
		allFibs.push(y)
	end
	return allFibs

		
	end
def cull(victim)
	evenFibs = Array.new()
	victim.each do |doodad| 
		if doodad%2==0
			evenFibs.push(doodad)
		end
		
	end
	return evenFibs
end
