class Topography
  attr_accessor :nb_inputs, :nb_outputs, :topography

  def initialize(nb_inputs, nb_outputs, hidden_layers_topography)
    @nb_inputs = nb_inputs
    @nb_outputs = nb_outputs

    @topography = hidden_layers_topography.clone
    @topography.unshift(nb_inputs)
    @topography.push(nb_outputs)
  end

  def each_n_np1(&block)
    for i in 0..(@topography.length - 2) do
      block.call(@topography[i], @topography[i+1])
    end
  end

end

