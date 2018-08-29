require_relative 'example'

ex = Example.new([1.0, 2.0], [1.0, 2.0])

puts "input dimension : #{ex.input_dimension}", "output dimension : #{ex.output_dimension}", "input :", ex.input, "output :", ex.output, " "

ex.input_dimension = 0
ex.output_dimension = 0

puts "input dimension : #{ex.input_dimension}", "output dimension : #{ex.output_dimension}", "input :", ex.input, "output :", ex.output

ex.input_dimension = 3
ex.output_dimension = 3

puts "input dimension : #{ex.input_dimension}", "output dimension : #{ex.output_dimension}", "input :", ex.input, "output :", ex.output, " "

ex.input_dimension = 1
ex.output_dimension = 2

puts "input dimension : #{ex.input_dimension}", "output dimension : #{ex.output_dimension}", "input :", ex.input, "output :", ex.output, " "

ex.input_dimension = 2
ex[5, :input] = 3.0

puts "input dimension : #{ex.input_dimension}", "output dimension : #{ex.output_dimension}", "input :", ex.input, "output :", ex.output, " "

ex.set_dimensions(7, 7)

puts "input dimension : #{ex.input_dimension}", "output dimension : #{ex.output_dimension}", "input :", ex.input, "output :", ex.output, " "

ex.print(5)
