defmodule Toolbox.Selection do
  def elite(population, n) do
    population
    |> Enum.take(n)
  end

  def random(population, n) do
    population
    |> Enum.take_random(n)
  end

  def tournament(population, n, tourn_size) do
    0..(n - 1)
    |> Enum.map(fn _ ->
      population
      |> Enum.take_random(tourn_size)
      |> Enum.max_by(& &1.fitness)
    end)
  end

  def roullete(_population, _n) do
    # Roulette selection attempts to balance genetic diversity and fitness based on
    # probability. Individuals that are more fit have a higher chance of getting
    # selected; however, it’s still possible that individuals that are less fit will get
    # selected as well. Think of it like this: in Wheel of Fortune, the more valuable
    # spaces have a smaller area, meaning the probability of landing on them is
    # lower. The relationship is the same in roulette selection, albeit in reverse.
    #
    # Roulette selection is by far the slowest and most difficult algorithm to implement;
    # however, it does a great job of maintaining the fitness of a population
    # while including some diverse parents.
  end
end
