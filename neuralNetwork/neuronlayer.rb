require_relative 'neuron'

class NeuronLayer
  attr_accessor :nb_inputs, :nb_neurons, :neurons, :function

  SIGMOID = Proc.new do |x|
    1.0 / (1.0 + Math::exp(-x))
  end

  def initialize(nb_inputs, nb_neurons, function = SIGMOID)
    @function = function
    @nb_inputs = nb_inputs
    @nb_neurons = nb_neurons
    
    @neurons = Array.new()
    @nb_neurons.times do
      @neurons.push(Neuron.new(@nb_inputs, @function))
    end
  end

  def compute(inputs)
    outputs = Array.new()

    @neurons.each do |neuron|
      outputs.push(neuron.compute(inputs))
    end

    return outputs
  end

end
    
