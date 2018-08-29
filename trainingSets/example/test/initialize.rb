# coding: utf-8
require_relative '../example'

# Ajout d'une fonctionde test de l'initialisation à la classe des exemples
class Example

  # Fonction de test d'initialisation, teste si l'exemple
  # correspond bien aux inputs et outputs donnés
  def well_initialized?(input = [], output = [], verbose = true)

    ### 1 - Vérification des arguments ###

    # On s'assure que l'input et l'output soient bien des arrays
    input = [] if !input.is_a?(Array)
    output = [] if !output.is_a?(Array)
    
    # On s'assure que verbose soit un booléen
    verbose = (verbose.to_s == "true")

    
    ### 2 - Test des dimensions ###
    # Test de la dimension d'entrée
    if @input.length != input.length then
      puts "Input dimensions is #{@input.length} instead of #{input.length}." if verbose
      return false
    end

    # Test de la dimension de sortie
    if @output.length != output.length then
      puts "Output dimensions is #{@output.length} instead of #{output.length}." if verbose
      return false
    end
    

    ### 3 - Test des valeurs ###

    # Test des valeurs de l'input
    for i in 0..(@input.length) do
      if @input[i] != input[i] then
        puts "Input ##{i} is #{@input[i]} instead of #{input[i]}." if verbose
        return false
      end
    end

    # Test des valeurs de l'output
    for i in 0..(@output.length) do
      if @output[i] != output[i] then
        puts "Output ##{i} is #{@output[i]} instead of #{output[i]}." if verbose
        return false
      end
    end
    

    ### 4 - Log et retour de fin ###
    
    puts "Initialization is valid for the given example,\
 dimesions (#{input.length}, #{output.length})." if verbose
    return true
  end
end

# Fonction de test de l'initialisation jusqu'aux dimensions données
def test_initialize(max_in_dim = 0, max_out_dim = 0, verbose = true, vverbose = false)

  ### 1 - Vérification des aruments ###
  
  # On s'assure que les dimensions max soient des entiers positifs
  max_in_dim = [0, max_in_dim.to_i].max
  max_out_dim = [0, max_out_dim.to_i].max

  # On s'assure que les options verbose soient des booléens
  verbose = (verbose.to_s == "true")
  vverbose = (vverbose.to_s == "true")

  ### 2 - Initialisation du module Random ###
  
  rng = Random.new

  
  ### 3 - Test pour chaque couple de dimension ###
  
  for in_dim in 0..max_in_dim do
    for out_dim in 0..max_out_dim do

      # On génère un input et un output aléatoires
      input = ([0] * in_dim).collect { rng.rand(1.0) }
      output = ([0] * out_dim).collect { rng.rand(1.0) }

      # On intialize un example avec ces données
      example = Example.new(input, output)

      # On test si l'initialisation a bien fonctionnée
      if !example.well_initialized?(input, output, vverbose) then
        puts "KO"
        puts "Initialization failed for dimensions (#{in_dim}, #{out_dim})." if verbose
        return false
      end
      
    end
  end

  
  ### 4 - Retour et Log de fin ###
  
  puts "OK"
  puts "Initialization is valid up to the dimensions (#{max_in_dim}, #{max_out_dim})." if verbose

  return true
end

# On récupère les arguments passés en console
max_in_dim, max_out_dim, verbose, vverbose = ARGV

# On lance le test avec les arguments récupérés
test_initialize(max_in_dim, max_out_dim, verbose, vverbose)
