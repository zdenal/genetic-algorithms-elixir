defmodule OneMax do
  @behaviour Problem

  alias Types.Chromosome

  @impl Problem
  def genotype do
    genes = for _ <- 1..42, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl Problem
  def fitness_function(%Chromosome{genes: genes}), do: Enum.sum(genes)

  @impl Problem
  def terminate?([best | _]), do: best.fitness == 42
end

soln = Genetic.run(OneMax)

IO.inspect(soln)
