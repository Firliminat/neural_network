require_relative 'neuronlayer'
require_relative 'topography'

class NeuronNetwork
  attr_accessor :topography, :layers, :function
  
  SIGMOID = Proc.new do |x|
    1.0 / (1.0 + Math::exp(-x))
  end

  def initialize(nb_inputs, nb_outputs, hidden_layers_topography, function = SIGMOID)
    @function = function
    @nb_inputs = nb_inputs
    @topography = Topography.new(nb_inputs, nb_outputs, hidden_layers_topography)

    @layers = Array.new()
    @topography.each_n_np1 do |nb_inputs, nb_neurons|
      @layers.push(NeuronLayer.new(nb_inputs, nb_neurons, function))
    end
  end

  def nb_inputs
    return @topography.nb_inputs
  end

  def nb_outputs
    return @topography.nb_outputs
  end

  def compute(inputs)
    values = inputs.clone
    @layers.each do |neuron_layer|
      values = neuron_layer.compute(values)
    end

    return values
  end
end

