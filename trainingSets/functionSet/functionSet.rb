# coding: utf-8
# Classe des ensembles de fonctions
# Composée d'un array pour l'input et un array pour l'output
# Cette classe contiendra les fonctions de dénormalization
class FunctionSet

  # On définit l'identité
  IDENTITY = Proc.new do |x|
    x
  end

  # Methode d'initialisation des ensembles de fonctions
  # Prend en entrée les dimensions d'entrées et de sortie
  # Créé un ensemble de fonction aux bonnes dimensions ayant pour seul fonction l'identité
  def initialize(input_dimension, output_dimension)
    # On transforme les dimensions en entiers positifs
    input_dimension = [0, input_dimension.to_i].max
    output_dimension = [0, output_dimension.to_i].max

    # On crée les tableaux
    @input = [IDENTITY] * input_dimension
    @output = [IDENTITY] * output_dimension
  end

  ###########
  # Getters #
  ###########

  ### Méthodes d'accès aux attributs ###
  
  # Retourne un clone de l'input
  # afin de ne pas permettre la modification de l'array sans respect de l'invariant
  def input
    ret = @input.clone
    return ret
  end

  # Retourne un clone de l'output
  # afin de ne pas permettre la modification de l'array sans respect de l'invariant
  def output
    ret = @output.clone
    return ret
  end

  # Permet d'accéder aux inputs et aux outputs
  # Comportements : Il y a 3 modes de fonctionnement :
  #                   - input  : Ne renvoit que des valeurs de l'input
  #                   - output : Ne renvoit que des valeurs de l'output
  #                   - both   : Renvoit des valeurs des deux, selon la valeur de n
  #                 Renvoit IDENTITY si l'on dépasse les dimensions
  #                 Fonctionne avec les Ranges
  def [](n, mode = :both)
    # Dans le cas où n est un Numeric
    if n.is_a? Numeric then
      # On le transforme en entier positif
      m = [0, n.to_i].max

      # En mode :input on va chercher que dans l'input
      if mode == :input then
        return @input[m] if m < self.input_dimension
        # Si on dépasse, on renvoit IDENTITY
        return IDENTITY
        
      # En mode :output on va chercher que dans l'output
      elsif mode == :output then
        return @output[m] if m < self.output_dimension
        # Si on dépasse, on renvoit IDENTITY
        return IDENTITY
        
      # En mode :both on va chercher que dans l'input ainsi que l'output
      else
        # Si n < input_dimension on passe en mode input
        return self[m, :input] if m < self.input_dimension
        # Sinon on passe en mode :output (en modifiant l'indice)
        return self[m - self.input_dimension, :output]
      end

    # Dans le cas où n est une Range
    elsif n.is_a? Range then
      # On le tranforme en une Range que l'on peut parcourir
      first, last = [n.first.to_i, n.last.to_i].minmax
      m = first..last

      # On crée l'Array de retour
      ret_arr = Array.new()
      # Pour chaque élément de l'interval de la Range
      for i in m do
        # On ajoute la valeur correspondante à l'Array de retour
        ret_arr.push(self[i, mode])
      end

      # On renvoit l'Array de retour
      return ret_arr
    end
  end

  ### Méthodes de calcul d'attributs ###
  
  # Renvoit la dimension d'entrée
  def input_dimension
    return @input.length
  end
  
  # Renvoit la dimension de sortie
  def output_dimension
    return @output.length
  end
  
  # Renvoit la somme des dimensions d'entrée et de sortie
  def total_dimension
    return self.input_dimension + self.output_dimension
  end

  ###########
  # Setters #
  ###########

  # Setter de la dimension d'input
  # Ajoute ou retire suffisemment de données
  # pour agrandir l'Array d'input à la taille souhaitée
  def input_dimension=(n)
    # On transforme l'entrée en un entier valide
    dim = [0, n.to_i].max

    # Si la dimension souhaitée est plus petite qu'actuellement
    if dim < self.input_dimension then
      # On coupe la fin de l'Array
      @input.slice_end!(dim)

    # Si la dimension souhaitée est plus grande qu'actuellement
    elsif dim > self.input_dimension then
      # On ajoute suffisemment de IDENTITY
      (dim - self.input_dimension).times { @input.push(IDENTITY) }
    end
  end

  # Setter de la dimension d'input
  # Ajoute ou retire suffisemment de données
  # pour agrandir l'Array d'output à la taille souhaitée
  def output_dimension=(dim)
    # On transforme l'entrée en un entier valide
    dim = [0, dim.to_i].max
    
    # Si la dimension souhaitée est plus petite qu'actuellement
    if dim < self.output_dimension then
      # On coupe la fin de l'Array
      @output.slice_end!(dim)

    # Si la dimension souhaitée est plus grande qu'actuellement
    elsif dim > self.output_dimension then
      # On ajoute suffisemment de IDENTITY
      (dim - self.output_dimension).times { @output.push(IDENTITY) }
    end
  end

  # Setter des deux dimensions à la fois
  # À l'aide des deux méthodes définies précédemment
  def set_dimensions(in_dim, out_dim)
    self.input_dimension = in_dim
    self.output_dimension = out_dim
  end

  # Setters des fonctions des inputs et des outputs
  # Comportements : Il y a 3 modes de fonctionnement :
  #                   - input  : Ne modifie que les valeurs de l'input
  #                   - output : Ne modifie que les valeurs de l'output
  #                   - both   : Modifie les valeurs des deux, selon la valeur de n
  #                 Ne fait rien si l'on dépasse les dimensions
  #                    sauf si on passe force à true
  #                 Fonctionne avec les Ranges
  def []=(n, mode = :both, force = false, value)
    # Dans le cas où n est un Numeric
    if n.is_a? Numeric then
      # On le transforme en entier
      m = [0, n.to_i].max

      # En mode :input on va modifier que dans l'input
      if mode == :input then
        # Si force est à true et que l'on veut ajouter une valeur hors des dimensions
        if force && (m >= self.input_dimension) then
          # On modifie la dimension
          self.input_dimension = m
          # On ajoute la valeur
          @input[m] = value

        # Sinon, si l'on doit modifier une valeur existante
        elsif m < self.input_dimension then
          # On modifie la valeur
          @input[m] = value
        end
      
      # En mode :output on va modifier que dans l'output
      elsif mode == :output then
        # Si force est à true et que l'on veut ajouter une valeur hors des dimensions
        if force && (m >= self.output_dimension) then
          # On modifie la dimension
          self.output_dimension = m
          # On ajoute la valeur
          @output[m] = value

        # Sinon, si l'on doit modifier une valeur existante
        elsif m < self.output_dimension then
          # On modifie la valeur
          @output[m] = value
        end
        
      # En mode :both on va modifier dans les deux
      else
        # Si n < input_dimension on passe en mode input
        if m < self.input_dimension
          self[m, :input, force] = value

        # Sinon on passe en mode :output (en modifiant l'indice)
        else
          self[m - self.input_dimension, :output, force] = value
        end
      end

    # Dans le cas où n est une Range
    elsif n.is_a? Range then
      # On le tranforme en une Range que l'on peut parcourir
      first, last = [first.to_i, last.to_i].minmax
      m = first..last

      # Si l'entrée est un Numeric on la transforme en Array de la bonne taille
      value = [value] * m.size if value.is_a? Numeric
      # Si l'entrée est trop petite on l'allonge à la bonne taille
      if m.size > value.length then
        # On push IDENTITY pour allonger à la bonne taille
        (value.length - m.size).times { value.push(IDENTITY) }
      end

      # Pour chaque élément de l'interval de la Range
      for i in m do
        # On modifie la valeur correspondante
        self[i, mode, force] = value[i]
      end
    end
  end

  ########################
  # Méthodes d'affichage #
  ########################
  
  # Renvoit une réprésentation de l'exemple sous forme de chaîne de caractères
  def to_s
    return "[#{input.to_s}, #{output.to_s}]"
  end

  # Affiche un exemple.
  # Si "print_title" est à true, affiche le nom des colonnes.
  # Par défaut : is_first = true
  def print(display_length = 5, print_title = true)
    # On transforme la taille d'affichage en un entier >= 4
    display_length = [5, display_length.to_i].max

    # On initialise les chaînes de caractères
    titles = "| " if print_title
    values = "| "

    # On récupère les inputs
    input_values = self.input
    # On les parcours
    input_values.each_index do |i|
      # On modifie les chaînes de caractères à l'aide des données
      titles << "%-#{display_length}s | " % "in #{i}" if print_title
      values << "%#{display_length}s | " % ("%.#{display_length - 3}f" % input_values[i])
    end
    
    titles << "| " if print_title
    values << "| "

    # On récupère les outputs
    output_values = self.output
    # On les parcours
    output_values.each_index do |i|
      # On modifie les chaînes de caractères à l'aide des données
      titles << "%-#{display_length}s | " %"out#{i}" if print_title
      values << "%#{display_length}s | " % ("%.#{display_length - 3}f" % output_values[i])
    end

    #On concatène le tout si nécessaire
    values = titles << "\n" << values if print_title

    #On affiche et retourne le résultat
    puts values   
    return values
  end
end
