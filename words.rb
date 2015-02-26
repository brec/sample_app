words = {}
File.open("/usr/share/dict/words") do |file|
	file.each do |line|
		words[line.strip] = true
	end
end

c = 0.0
count = 100000
for i in 0..count
	word = ('a'..'z').to_a.shuffle.join[0..5]
	if words[word]
		puts word
		c = c + 1
	end
end
puts c
puts c/count