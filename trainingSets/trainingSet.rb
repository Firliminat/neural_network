# coding: utf-8
require_relative 'array'
require_relative 'example'
require_relative 'functionset'

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
      output = outputs[i][0..(input_dimension - 1)]
      # On crée l'exemple et on l'ajoute à l'Array
      examples.push(Example.new(input, output))
    end

    # On renvoit l'Array construit et ses dimensions
    return [examples, input_dimension, output_dimension]
  end
end

# Classe des ensembles d'apprentissage
# Une instance est composée de :
#  - Un array d'exemples
#  - Une dimension d'entrée
#  - Une dimension de sortie
#  - Un tableau de fonctions de dénormalisations
# Invariants :
#  - Les dimensions d'input et d'ouput de chaque exemple
#      correspondent aux dimensions du TrainingSet
#  - Chaque fonction de l'Array de dénormalization
#      permet de revenir aux données initiales
class TrainingSet
  attr_reader :input_dimension, :output_dimension, :denormalize_functions

  # Initialisation d'une instance
  # On transforme l'input et l'output en examples :
  #   On ne garde que les dimensions les plus petites, pour le nb d'exemples conservés
  #   Par exemple, s'il y a 4 inputs différents de dimensions 3, 4, 4 et 2
  #   et 2 outputs de dimensions 2 et 3, alors on ne conserve que les 2 premiers inputs
  #   et ouputs, puis on choisit pour les restants les dimensions les plus petites,
  #   ici inout : 3 et output : 2.
  # On initialise les autres attributs de façon à vérifier l'invariant.
  def initialize(inputs, outputs)
    @examples, @input_dimension, @output_dimension = [inputs, outputs].to_examples
    
    @denormalize_functions = DenormalizeFunctionsSet.new(self.input_dimension, self.output_dimension)
  end

  ###########
  # Getters #
  ###########

  ### Méthodes d'accès aux attributs ###

  # Retourne un clone de l'array des exemples
  # Pour que l'on ne puisse pas modifier les exemples sans passer par l'opérateur de classe
  def examples
    ret = @examples.clone
    return ret
  end

  # Permet d'accéder aux données
  # Comportements : Il y a 3 modes de fonctionnement :
  #                   - input  : Ne renvoit que des valeurs de l'input
  #                   - output : Ne renvoit que des valeurs de l'output
  #                   - both   : Renvoit des valeurs des deux, selon la valeur de dim
  #                 Renvoit 0.0 si l'on dépasse les dimensions
  #                 Fonctionne avec les Ranges
  # Cf accesseur [] de la classe Example (example.rb)
  def [](num_ex, dim, mode = :both)
    if num_ex.is_a? Numeric then
      # On le transforme en entier valide
      num_ex_c = [0, num_ex.to_i].max

      # Si on dépasse le nombre d'exmeples
      if num_ex_c >= self.size then
        # On crée un exemple aux dimension du TrainingSet ne contenant que des 0.0
        ex = Example.new([0.0] * self.input_dimension, [0.0] * self.output_dimension)
        
        # On appelle le getter de cet exemple 
        return ex[dim, mode]
      end
      
      # On renvoit la/les dimension(s) demandée(s) de l'exemple demandé
      return @examples[num_ex_c][dim, mode]

    # Sinon si l'on nous demande une Range
    elsif num_ex.is_a? Range then
      # On le tranforme en une Range que l'on peut parcourir
      first, last = [num_ex.first.to_i, num_ex.last.to_i].minmax
      num_ex_c = first..last

      # On crée l'Array de retour
      ret_arr = Array.new()
      # Pour chaque élément de l'interval de la Range
      for i in num_ex_c do
        # On ajoute la valeur correspondante à l'Array de retour
        ret_arr.push(self[i, dim, mode])
      end

      # On renvoit l'Array de retour
      return ret_arr
    end
  end
  
  # Renvoit la taille du training set
  # i.e. le nombre d'exemples
  def size
    return @examples.length
  end

  # Renvoit les inputs
  def inputs
    return self[0..(self.size - 1), 0..(self.input_dimension - 1), :input]
  end

  # Renvoit les outpus
  def outputs
    return self[0..(self.size - 1), 0..(self.output_dimension - 1), :output]
  end

  # Renvoit la dimension du training set
  # i.e. la somme des dimensions de l'input et de l'output
  def total_dimension
    return self.input_dimension + self.output_dimension
  end

  ###########
  # Setters #
  ###########
  
  # Ajoute un example au training set
  # On redimensionne l'exemple aux dimensions du training set avant l'ajout
  def add_example(example)
    # On redimensionne l'exemple
    example.set_dimensions(self.input_dimension, self.output_dimension)
    # On l'ajoute
    @examples.push(example)
  end

  # Enlève un exemple au training set et renvoit l'exemple supprimé
  # On vérifie d'abord si ses dimensions correspondent à celles du training set
  # afin de gagner du temps
  def delete_example(example)
    # On vérifie si les dimensions correspondent
    return nil if example.input_dimension != self.input_dimension ||\
                  example.output_dimension != self.output_dimension
    # Si c'est le cas on supprime l'exemple
    # (l'opérateur d'égalité des exemples a été surchargé)
    return @examples.delete(example)
  end  

  # Setter de la taille du training set
  # Ajoute ou retire suffisemment de données
  # pour agrandir l'Array des exemples à la taille souhaitée
  def size=(n)
    # On transforme la dimension donnée en entier valide
    n = [0, n.to_i].max
    
    # Si la dimension souhaitée est plus petite qu'actuellement
    if n < self.size then
      # On coupe la fin de l'Array
      @examples.slice_end!(dim)

    # Si la dimension souhaitée est plus grande qu'actuellement
    elsif n > self.size then
      # On crée un exemple aux dimension du TrainingSet ne contenant que des 0.0
      empty_ex = Example.new([0.0] * self.input_dimension, [0.0] * self.output_dimension)
      # On l'ajoute suffisemment de fois
      (n - self.size).times { @examples.add_example(empty_ex) }
    end
  end

  # Setter de la dimension d'input du training set
  def input_dimension=(in_dim)
    # On transforme la nouvelle dimension en un entier positif
    in_dim = [0, in_dim.to_i].max
    
    # On modifie la dimension de chaque exemple
    @exaples.each { |example| example.input_dimension = in_dim } if in_dim != self.input_dimension

    # On modifie le tableau des fonctions de dénormalisation
    # Dans le cas où la nouvelle dimension est plus petite
    if in_dim < self.input_dimension then
      # On supprime les dimensions à enlever
      for i in in_dim..(self.input_dim - 1) do
        @denormalize_functions.delete_at((self.input_dim - 1) - i + in_dim)
      end

    # Dans le cas où la nouvelle dimension est plus grande
    elsif in_dim > self.input_dimension then
      # On ajoute le bon nombre de dimensions
      for i in (self.input_dim)..(in_dim - 1) do
        @denormalize_functions.insert(i, IDENTITY)
      end
    end

    # On modifie la dimension sauvegardée
    @input_dimension = in_dim
  end

  # Setter de la dimension d'output du training set
  def output_dimension=(out_dim)
    # On transforme la nouvelle dimension en un entier positif
    out_dim = [0, out_dim.to_i].max
    
    # On modifie la dimension de chaque exemple
    @exaples.each { |example| example.output_dimension = out_dim }

    # On modifie le tableau des fonctions de dénormalisation
    # Dans le cas où la nouvelle dimension est plus petite
    if out_dim < self.output_dimension then
      # On supprime les dimensions à enlever
      for i in out_dim..(self.output_dim - 1) do
        @denormalize_functions.delete_at((self.output_dim - 1) - i + out_dim + self.input_dimension)
      end

    # Dans le cas où la nouvelle dimension est plus grande
    elsif out_dim > self.output_dimension then
      # On ajoute le bon nombre de dimensions
      for i in (self.output_dim)..(out_dim - 1) do
        @denormalize_functions.insert(i + self.input_dimension, IDENTITY)
      end
    end

    # On modifie la dimension sauvegardée
    @output_dimension = out_dim
  end

  # Setter des dimensions d'input et d'output du training set
  def set_dimension(in_dim, out_dim)
    # On modifie les deux dimensions
    self.input_dimension = in_dim
    self.output_dimension = out_dim
  end
  
  # Permet de modifier les données
  # Comportements : Il y a 3 modes de fonctionnement :
  #                   - input  : Ne modifie que les valeurs de l'input
  #                   - output : Ne modifie que les valeurs de l'output
  #                   - both   : Modifie les valeurs des deux, selon la valeur de dim
  #                 Ne fait rien si l'on dépasse les dimensions
  #                   sauf si on passe force à true
  #                 Fonctionne avec les Ranges
  # Cf setter []= de la classe Example (example.rb)
  def []=(num_ex, dim, mode = :both, force = false, value)
    # Dans le cas où le numéro de l'exemple est un Numeric
    if num_ex.is_a? Numeric then
      # On le transforme en entier valide
      num_ex_c = [0, num_ex.to_i].max

      # Si on dépasse le nombre d'exmeples et que force est à true
      if force && num_ex_c >= self.size then
        # On agrandit le training set
        self.size = num_ex_c + 1
      end

      # Si force est à true
      if force then
        # On récupère la dimension maximale demandée
        if dim.is_a? Numeric then
          max_dim = [0, dim.to_i].max
        elsif dim.is_a? Range then
          max_dim = [0, dim.first.to_i, dim.last.to_i].max
        end
      end
      
      # Si on dépasse la dimension d'input, que force est à true et que le mode est :input
      if force && mode == :input && max_dim >= self.input_dimension then
        # On modifie la taille du training set
        self.input_dimension = max_dim + 1
      end

      # Si on dépasse la dimension d'output, que force est à true et que le mode est :output
      if force && mode == :output && max_dim >= self.output_dimension then
        # On modifie la taille du training set
        self.output_dimension = max_dim + 1
      end

      # Si on dépasse la dimension totale, que force est à true et que le mode est :both
      if force && mode == :both && dim >= self.total_dimension then
        # On modifie la taille du training set
        self.output_dimension = max_dim + 1
      end
      
      # On modifie la/les donnée(s) demandée(s)
      @examples[num_ex_c][dim, mode, force] = value

    elsif num_ex.is_a? Range then
      # On le tranforme en une Range que l'on peut parcourir
      first, last = [num_ex.first.to_i, num_ex.last.to_i].minmax
      num_ex_c = first..last

      # Pour chaque élément de l'interval de la Range
      for i in num_ex_c do
        # On modifie la valeur correspondante
        self[i, dim, mode, force] = value[[value.length, i].min]
      end
    end
  end
  
  # Fonction de centrage + réduction de dimensions
  def normalize_dimension(n, mode = :both)
    # Si n est numérique
    if n.is_a? Numeric then
      # On le transforme en entier valide
      n = [0, n.to_i].max
      
      # On récupère la valeur de cette diension pour chaque exemple
      normalized_dimension = self[0..(self.size - 1), n, mode]
      # On centre + réduit ce tableau et on garde la moyenne et l'écarte type
      avg, ecart_type = normalized_dimension.normalize!

      # On modifie la dimension avec les valeurs contrées réduites
      self[0..(self.size - 1), n] = normalized_dimension

      # On modifie la fonction de denormalisation
      self.denormalize_functions[n, mode] = Proc.new do |x|
        x * ecart_type + avg
      end
    elsif n.is_a? Range then
    end
  end

  def normalize_inputs
    for n in 0..(@input_dimension - 1) do
      normalize_nth_input(n)
    end
  end

  def normalize_outputs
    for m in 0..(@output_dimension - 1) do
      normalize_mth_output(m)
    end
  end

  def normalize
    normalize_inputs
    normalize_outputs
  end

  ########################
  # Méthodes d'affichage #
  ########################
  
  # Renvoit une réprésentation du training set sous forme de chaîne de caractères
  def to_s
    # On initialise la chaîne de retour
    ret = ""
    @examples.each do |ex|
      # On y ajoute la représentation de chaque exemple en sautant une ligne
      ret << ex.to_s << "\n"
    end

    # On renvoit la chaîne de retour
    return ret
  end

  # Affiche un trainingset.
  # Si "print_title" est à true, affiche le nom des colonnes.
  # Par défaut : is_first = true
  def print(display_length = 5, print_title = true)
    # On initialise la chaine de retour
    ret = ""
    @examples.each_index do |i|
      # On affiche chaque exemple et on ajoute la chaîne
      ret << @examples[i].print(display_length, (i == 0) && print_title) << "\n"
    end

    # On renvoit la chaîne
    return ret
  end  
end
