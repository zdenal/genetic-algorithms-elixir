# mix run scripts/codebreaker.exs

# Some hacker encrypt your computer with XOR cipher.
# Luckily, you remember one of the names of the files on your desktop:
# ILoveGeneticAlgorithms. It appears the name of this file has been changed to
# LIjs`B`k`qlfDibjwlqmhv. Given you have an encrypted string, and you know the
# decrypted version, you can guess a key and apply it on your encrypted string
# to see how close it gets you to the decrypted version (use in fitness function)

defmodule Codebreaker do
  @behaviour Problem
  alias Types.Chromosome

  use Bitwise

  @size 64

  @impl Problem
  def genotype do
    genes = for _ <- 1..@size, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: @size}
  end

  @impl Problem
  def fitness_function(chromosome) do
    target = "ILoveGeneticAlgorithms"
    encrypted = 'LIjs`B`k`qlfDibjwlqmhv'
    cipher = fn word, key -> Enum.map(word, &rem(&1 ^^^ key, 32768)) end

    key =
      chromosome.genes
      |> Enum.map(&Integer.to_string(&1))
      |> Enum.join("")
      |> String.to_integer(2)

    guess = List.to_string(cipher.(encrypted, key))
    String.jaro_distance(target, guess)
  end

  @impl Problem
  def terminate?([best | _tail], _temperature) do
    # Enum.max_by(population, &Codebreaker.fitness_function/1).fitness == 1
    best.fitness == 1
  end
end

soln = Genetic.run(Codebreaker, crossover_type: &Toolbox.Crossover.single_point/2)

{key, ""} =
  soln.genes
  |> Enum.map(&Integer.to_string(&1))
  |> Enum.join("")
  |> Integer.parse(2)

IO.write("\nThe Key is #{key}\n")
