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
end
