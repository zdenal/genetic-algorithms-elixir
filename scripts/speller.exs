defmodule Speller do
  @behaviour Problem

  alias Types.Chromosome

  @impl Problem
  def genotype do
    genes =
      Stream.repeatedly(fn -> Enum.random(?a..?z) end)
      |> Enum.take(34)

    %Chromosome{genes: genes, size: 34}
  end

  @impl Problem
  def fitness_function(%Chromosome{genes: genes}) do
    List.to_string(genes)
    |> String.jaro_distance("supercalifragilisticexpialidocious")
  end

  @impl Problem
  def terminate?([%Chromosome{fitness: fitness} = _best | _]), do: fitness == 1
end

soln = Genetic.run(Speller)

IO.inspect(soln)
