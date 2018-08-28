require_relative 'example'

ex = Example.new([1.0, 2.0], [3.0])

puts "ex :\ninput dimension : #{ex.input_dimension}", "output dimension : #{ex.output_dimension}", "input :", ex.input, "output :", ex.output

puts "input : ", ex[0..3, :input]
puts "input 0 : #{ex[0, :input]}"
puts "output : ", ex[0..3, :output]
puts "both : ", ex[0..3]


ex2 = Example.new([1.0, 2.0], [3.0])

puts "\nex2 :\ninput dimension : #{ex2.input_dimension}", "output dimension : #{ex2.output_dimension}", "input :", ex2.input, "output :", ex2.output

ex3 = Example.new([1.5, 2.0], [3.0])
ex4 = Example.new([1.0, 2.5], [3.0])
ex5 = Example.new([1.0, 2.0], [3.5])

puts "\nex == ex2 recpiroque : #{ex == ex2} #{ex2 == ex}"
puts "ex == ex3 recpiroque : #{ex == ex3} #{ex3 == ex}"
puts "ex == ex4 recpiroque : #{ex == ex4} #{ex4 == ex}"
puts "ex == ex4 recpiroque : #{ex == ex5} #{ex5 == ex}"

puts "\n#{ex.to_s}"
