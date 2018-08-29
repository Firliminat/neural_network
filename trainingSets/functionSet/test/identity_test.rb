# coding: utf-8
require_relative '../../functionSet'

# Tests a proc to know if it's identity on not at the precision given.
def identity_test(proc, precision = 10000, verbose = false)
  # Seeting up the test boolean
  test_result = true
  
  # Transforming the number of tests to a strictily positive integer
  precision = [1, precision.to_i].max

  # Iterating from 0 to the max
  for i in 0..precision do
    # 1st we calculate the value to test
    test_value = i.to_f / (precision.to_f)
    # Then if the identity doesn't return the value it was given
    if proc.call(test_value) != test_value then
      # We set the result to false
      test_result = false
      # And we stop iterating
      break
    end
  end

  # Then we display the result of the test if verbose is on
  if verbose then
    if test_result then
      puts "OK", "Function given seems to be IDENTITY at test precision of #{precision}."
    else
      STDERR.puts "KO /!\\./!\\./!\\", "Function given differs from IDENTITY at test value #{test_value}, at iteration number #{i} with precision #{precision}."
    end
  end

  return test_result
end

# On récupère les arguments passés en console
precision, verbose = ARGV

# On lance le test avec les arguments récupérés
identity_test(FunctionSet::IDENTITY, precision.to_i, verbose.to_s == "true")
