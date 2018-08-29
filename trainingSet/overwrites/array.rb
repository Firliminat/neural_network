# coding: utf-8
require_relative '../example/example'

# Ajout d'une méthode de transformation d'un array vers un array d'exemples
class Array
  # Transforme un array en array d'exemple
  # S'applique à un array de la forme : [inputs, outputs]
  # inputs = [input_1, ..., input_k]
  # outputs = [output_1, ..., output_l]
  # input_i = [val_1, ..., val_mi]
  # output_j = [val_1, ..., val_nj]
  # Sortie : [array des exemples, dimension des inputs = [mi].min,
  #           dimension des outputs = [nj].min]
  # N.B. : La méthode ne garde que les dimensions les plus petites
  #        que ce soit pour les dimensions d'entrée et de sortie ou pour le nombre d'examples.
  #        Par exemple, il y a 3 entrées et 4 sorties, seulement 3 exemples seront créés
  #        De même, si un exemple à une dimension d'entrée de 3 et tous les autres de 4,
  #        alors la dimension d'entrée conservée sera 3.
  def to_examples
    # On récupère les inputs et les outputs
    inputs = self[0]
    outputs = self[1]

    # Calculs des dimensions
    # On garde autant d'example que le minimum d'input ou d'output
    nb_examples = [inputs.length, outputs.length].min
    # Pour le calcul des dimensions d'input et d'output
    # on ne le fait que sur ceux qui seront gardés
    input_dimension = (inputs.slice_end(nb_examples).collect { |arr| arr.length }).min
    output_dimension = (outputs.slice_end(nb_examples).collect { |arr| arr.length }).min

    # Création de l'array des Examples
    examples = Array.new()

    # Pour chaque example
    for i in 0..(nb_examples - 1) do
      # On coupe l'input et l'output à la dimension définie 
      input = inputs[i][0..(input_dimension - 1)]
      output = outputs[i][0..(output_dimension - 1)]
      # On crée l'exemple et on l'ajoute à l'Array
      examples.push(Example.new(input, output))
    end

    # On renvoit l'Array construit et ses dimensions
    return [examples, input_dimension, output_dimension]
  end
end
