# mix run scripts/n_queens.exs

defmodule NQueens do
  @behaviour Problem

  alias Types.Chromosome

  @size 8

  @impl Problem
  def genotype do
    genes = Enum.shuffle(0..7)
    %Chromosome{genes: genes, size: @size}
  end

  @impl Problem
  def fitness_function(chromosome) do
    diag_clashes =
      for i <- 0..7, j <- 0..7 do
        if i != j do
          dx = abs(i - j)

          dy =
            abs(
              chromosome.genes
              |> Enum.at(i)
              |> Kernel.-(Enum.at(chromosome.genes, j))
            )

          if dx == dy do
            1
          else
            0
          end
        else
          0
        end
      end

    length(Enum.uniq(chromosome.genes)) - Enum.sum(diag_clashes)
  end

  @impl Problem
  def terminate?(population, _temperature) do
    Enum.max_by(population, & &1.fitness).fitness == @size
  end
end

# Single point crossover NOT working on permutation list
# soln = Genetic.run(NQueens, crossover_type: &Toolbox.Crossover.single_point/2)

# Order One crossover IS working on permutation list
soln = Genetic.run(NQueens, crossover_type: &Toolbox.Crossover.order_one/2)

IO.inspect(soln)
