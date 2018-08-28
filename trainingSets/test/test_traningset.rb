require_relative '../../trainingset'

tr_set = TrainingSet.new([[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0], [0.5, 0.5]], [[0.0], [1.0], [1.0], [0.0]])

puts "training set size : #{tr_set.size}", "input dimension : #{tr_set.input_dimension}", "output dimension : #{tr_set.output_dimension}", "examples :", tr_set.examples, " ", "inputs :",  tr_set.inputs, " ", "outputs :", tr_set.outputs, " "

puts "inputs 0 | inputs 1 | output"

for i in 0..3 do
  puts "#{tr_set[i, 0]}      | #{tr_set[i, 1]}      | #{tr_set[i, 2]}"
end

puts " "

print tr_set[0..5, 1]

puts " ", " "

tr_set[0..5, 0..5].each do |arr|
  print arr
  print "\n"
end

puts "add example Example.new([0.5, 0.5], [0.5]) :"
add_delete_ex = Example.new([0.5, 0.5], [0.5])
tr_set.add_example(add_delete_ex)
puts "training set size : #{tr_set.size}", "input dimension : #{tr_set.input_dimension}", "input dimension : #{tr_set.output_dimension}"

puts "delete example Example.new([0.5, 0.5], [0.5]) :"
tr_set.delete_example(Example.new([0.5, 0.5], [0.5]))
puts "training set size : #{tr_set.size}", "input dimension : #{tr_set.input_dimension}", "input dimension : #{tr_set.output_dimension}"

puts "add example Example.new([0.5, 0.5], [0.5]) :"
add_delete_ex = Example.new([0.5, 0.5], [0.5])
tr_set.add_example(add_delete_ex)
puts "training set size : #{tr_set.size}", "input dimension : #{tr_set.input_dimension}", "input dimension : #{tr_set.output_dimension}"

puts "delete example added :"
tr_set.delete_example(add_delete_ex)
puts "training set size : #{tr_set.size}", "input dimension : #{tr_set.input_dimension}", "input dimension : #{tr_set.output_dimension}"

puts " ", "total dimension : #{tr_set.total_dimension}", " "

puts "normalize dim 1"
tr_set.normalize_dimension(1)

tr_set.print
puts " "

for i in 0..3 do
  str = ""
  for j in 0..2 do
    str << "#{tr_set.denormalize_functions[j].call(tr_set[i, j])}  | "
  end
  puts str
end

