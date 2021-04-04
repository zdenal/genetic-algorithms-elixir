defmodule Toolbox.Crossover do
  alias Types.Chromosome

  def single_point(p1, p2) do
    cx_point = :rand.uniform(length(p1.genes))
    {h1, t1} = Enum.split(p1.genes, cx_point)
    {h2, t2} = Enum.split(p2.genes, cx_point)

    {
      %Chromosome{p1 | genes: h1 ++ t2},
      %Chromosome{p2 | genes: h2 ++ t1}
    }
  end

  def order_one(p1, p2) do
    size = p1.size - 1

    {from, to} =
      [:rand.uniform(size), :rand.uniform(size)]
      |> Enum.sort()
      |> List.to_tuple()

    slice1 = Enum.slice(p1.genes, from..to)
    {head1, tail1} = (p2.genes -- slice1) |> Enum.split(from)

    slice2 = Enum.slice(p2.genes, from..to)
    {head2, tail2} = (p1.genes -- slice2) |> Enum.split(from)

    {
      %Chromosome{
        genes: head1 ++ slice1 ++ tail1,
        size: p1.size
      },
      %Chromosome{
        genes: head2 ++ slice2 ++ tail2,
        size: p1.size
      }
    }
  end

  def uniform(p1, p2, rate = 0.5) do
    {ch1, ch2} =
      p1.genes
      |> Enum.zip(p2.genes)
      |> Enum.map(fn {x, y} ->
        if :rand.uniform() < rate do
          {x, y}
        else
          {y, x}
        end
      end)
      |> Enum.unzip()

    {
      %Chromosome{p1 | genes: ch1},
      %Chromosome{p2 | genes: ch2}
    }
  end

  def whole_arithmetic_recombination(p1, p2, alpha) do
    # Whole arithmetic recombination, like uniform crossover, iterates over entire
    # chromosomes. This means it will be slower on larger solutions. It can be
    # useful with floating-point solutions—like in portfolio optimization and determining
    # what percentage of your portfolio to allocate to each asset.
    {ch1, ch2} =
      p1.genes
      |> Enum.zip(p2.genes)
      |> Enum.map(fn {x, y} ->
        {x * alpha + y * (1 - alpha), x * (1 - alpha) + y * alpha}
      end)
      |> Enum.unzip()

    {
      %Chromosome{p1 | genes: ch1},
      %Chromosome{p2 | genes: ch2}
    }
  end
end
