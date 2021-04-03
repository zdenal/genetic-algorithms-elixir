defmodule Portfolio do
  @behaviour Problem

  alias Types.Chromosome

  @target_fitness 180

  @impl Problem
  def genotype do
    genes = for _ <- 1..10, do: {:rand.uniform(10), :rand.uniform(10)}
    %Chromosome{genes: genes, size: 10}
  end

  @impl Problem
  def fitness_function(%Chromosome{genes: genes}) do
    genes
    |> Enum.map(fn {roi, risk} -> 2 * roi - risk end)
    |> Enum.sum()
  end

  @impl Problem
  def terminate?([%Chromosome{fitness: fitness, age: age} | _], temperature) do
    fitness > @target_fitness
  end
end

soln = Genetic.run(Portfolio, population_size: 50)

IO.inspect(soln)
