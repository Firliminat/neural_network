class Neuron
  attr_accessor :nb_inputs, :weights, :function

  SIGMOID = Proc.new do |x|
    1.0 / (1.0 + Math::exp(-x))
  end
  
  def initialize(nb_inputs, function = SIGMOID)
    @function = function
    @nb_inputs = nb_inputs

    @weights = Array.new()
    (@nb_inputs + 1).times do
      @weights.push((rand - 0.5) * 10.0)
    end
  end

  def compute(inputs)
    sum = 0.0
    for i in 0..(@nb_inputs - 1) do
      sum += inputs[i] * @weights[i]
    end

    sum += @weights[@nb_inputs]

    return @function.call(sum)
  end
  
end
