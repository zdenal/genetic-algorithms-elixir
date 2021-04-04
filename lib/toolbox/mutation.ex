defmodule Toolbox.Mutation do
  alias Types.Chromosome

  use Bitwise

  def flip(chromosome) do
    # 0 -> 1
    # 1 -> 0
    # Achived by using XOR with 1. So 0 XOR 1 -> 1, 1 XOR 1 -> 0
    chromosome.genes
    |> Enum.map(&(&1 ^^^ 1))
    |> update_genes(chromosome)
  end

  def scrable(chromosome) do
    chromosome.genes
    |> Enum.shuffle()
    |> update_genes(chromosome)
  end

  def guassian(chromosome) do
    # Gaussian mutation is a mutation operator meant specifically for real-value
    # representations of chromosomes. It generates Gaussian random numbers
    # based on the provided chromosome. A Gaussian random number is just a
    # random number from a normal distribution.
    # In Gaussian mutation, you calculate the mean and standard deviation of the
    # genes in the chromosome, and then use them to generate numbers in the
    # distribution.
    # The idea behind Gaussian mutation is that you are able to slightly adjust a
    # chromosome without changing it too much. The random numbers that replace
    # the genes in your chromosome belong to the same distribution as the existing
    # genes in your chromosome.
    mean = Enum.sum(chromosome.genes) / length(chromosome.genes)

    std =
      chromosome.genes
      |> Enum.map(fn x -> (mean - x) * (mean - x) end)
      |> Enum.sum()
      |> Kernel./(length(chromosome.genes))

    chromosome.genes
    |> Enum.map(fn _ ->
      :rand.normal(mean, std)
    end)
    |> update_genes(chromosome)
  end

  def swap(_chromosome) do
    # swap random pairs of genes
  end

  def uniform(_chromosome) do
    # replace genes with uniform random numbers
  end

  def invert(chromosome) do
    # invert the order of the chromosome.
    chromosome.genes |> Enum.reverse() |> update_genes(chromosome)
  end

  defp update_genes(genes, chromosome), do: %Chromosome{chromosome | genes: genes}
end
