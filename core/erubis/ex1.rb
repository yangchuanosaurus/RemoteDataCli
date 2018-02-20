require 'erubis'

input = File.read('ex1.eruby')
eruby = Erubis::Eruby.new(input)

puts "-------- Script Source --------"
puts eruby.src

puts "-------- results --------"
list = ['aaa', 'bbb', 'ccc']
puts eruby.result(binding())