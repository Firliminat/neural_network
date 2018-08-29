# coding: utf-8

# Ajout des méthode de transformation des données à la classe objet
class Object

  # Renvoit l'objet à partir du quel la fonction est appelée transformé en int
  # compris entre arg1 et arg2.
  #   Si un des argument est nil alors la frontière correspondante est ignorée.
  #   Si arg1 est une range (de la forme x..y) alors le min (resp. max) de {x, y}
  #   sera utilisé comme frontière min (resp. max). arg2 est ignoré.
  def to_i_bounded(arg1 = 0, arg2 = nil)
    
    # Si arg1 est une range
    if arg1.is_a ? Range then
         # On transforme en entiers et on récupère le min et le max de la range
         min, max = [arg1.first.to_i, arg1.last.to_i].minmax
         # Puis on appelle la fonction avec deux arguments
         return self.to_i_bounded(min, max)
    end

    # On transforme l'objet en entier
    ret = self.to_i

    # On applique la frontière min si nécessaire
    ret = [arg1.to_i, ret].max if !arg1.nil?
    
    # On applique la frontière max si nécessaire
    return [ret, arg2.to_i].min if !arg2.nil?

    # On renvoit le résultat
    return ret
  end

  # Renvoit l'objet à partir du quel la fonction est appelée transformé en int
  # compris entre arg1 et arg2 et effectue cette transformation. (Par effet)
  #   Si un des argument est nil alors la frontière correspondante est ignorée.
  #   Si arg1 est une range (de la forme x..y) alors le min (resp. max) de {x, y}
  #   sera utilisé comme frontière min (resp. max). arg2 est ignoré.
  def to_i_bounded!(arg1 = 0, arg2 = nil)
    
    # On applique la transformation
    self = self.to_i_bounded(arg1, arg2)

    # On revoit le résultat
    return self
  end

  # Function renvoyant self transformé en bool.
  #   Vérifie simplement si self transformé en string est dans l'array des valeurs acceptées
  def to_bool(array_of_true_values = ["vrai", "1"])
    # On ajoute la string "true au début pour s'assurer que true renvoit true
    array_of_true_values.unshift(["true"])

    # On renvoit true si self transformé en string est dans l'array des valeurs acceptées
    return array_of_true_values.any? { |key_word| self.to_s == key_word }
  end

  # Idem au dessus mais par effet
  def to_bool!(array_of_true_values = ["vrai", "1"])
    # On applique la fonction précédente à self et on écrase self
    self = self.to_bool(array_of_true_values)
    # On retourne le résultat
    return self
  end

  # Transforme self en float par effet
  def to_f!
    # On applique la fonction to_f à self et on écrase self
    self = self.to_f
    # On retourne le résultat
    return self
  end

    
