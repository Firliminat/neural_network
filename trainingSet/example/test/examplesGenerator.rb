# coding: utf-8
require_relative '../example'

# Ajout d'une fonction de génération aléatoire d'exemples
class Example

  # Fonction de génération aléatoire d'examples
  # Génère le nombre d'exmples données selon les options spécifiées
  def rendom_generation(nb_examples = 1, default_value = nil,\
                        default_in_dim = nil, default_out_dim = nil, verbose = false)

    ### 1 - Vérification des arguments ###

    # On s'assure que les numériques soient biens du bon type
    nb_examples.to_i_bounded!(0)
    default_value.to_f! if !default_value.nil?
    default_in_dim.to_i_bounded!(0) if !default_in_dim.nil?
    default_in_dim.to_i_bounded!(0) if !default_out_dim.nil?
    
    # On s'assure que verbose soit un booléen
    verbose.to_bool!
    
  end
end
