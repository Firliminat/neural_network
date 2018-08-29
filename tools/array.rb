# coding: utf-8
# Ajout de méthodes outils à la classe des Arrays
class Array
  
  # Coupe la fin de l'Array
  # Agit par effet
  def slice_end!(n)
    # On transforme n en un entier valide
    m = [0, n.to_i].max
    # On utilise la méthode native slice!
    return self.slice!(n, size)
  end

  # Coupe la fin de l'Array
  # Agit par valeur (utilise la fonction définie préédemment)
  def slice_end(n)
    # On clone l'Array
    arr_ret = self.clone
    # On lui applique la fonction agissant par effet sur le clone
    arr_ret.slice_end!(n)
    # On renvoit le clone modifié
    return arr_ret
  end

  # Somme tous les éléments d'un Array
  def sum
    # On initie la valeur de la somme
    s = 0.0
    # Pour chaque élément de l'Array
    self.each do |x|
      # On l'additionne à la somme
      s += x
    end
    # On renvoit le total
    return s
  end

  # Moyenne des éléments d'un Array
  def mean
    # On somme ses éléments et on divise par le nombre d'éléments
    return self.sum / (size.to_f)
  end

  # Variance des éléments d'un Array
  def variance
    # On calcule la moyenne de l'Array
    avg = self.mean
    # On construit l'Array des écarts à la moyenne au carré
    ecarts = self.collect {|x| (x - avg) ** 2.0}
    # On renvoit la moyenne de ces écarts
    return ecarts.mean
  end

  # Ecart-type des éléments d'un Array
  def std_dev
    # On renvoit la racine carré de la variance
    return Math::sqrt(self.variance)
  end

  # Méthode centrant et réduisant l'Array
  # Agit par effet
  def normalize!
    # Calcul de la moyenne et de l'écart-type
    avg = self.mean
    ecart_type = self.std_dev

    # On soustrait la moyenne et on divise par l'écart-type
    self.collect! {|x| (x - avg) / ecart_type}
    # On renvoit la moyenne et l'écart-type afin de
    # pouvoir construire une fonction de dénormalisation
    return [avg, ecart_type]
  end

  # Méthode centrant et réduisant l'Array
  # Agit par valeur
  # (ne permet pas de construire une fonction de dénormalisation)
  def normalize
    # On clone l'array
    ret_arr = self.clone
    # On lui applique la fonction agissant par effet
    ret_arr.normalize!
    # On renvoit le clone modifié
    return ret_arr
  end
end
