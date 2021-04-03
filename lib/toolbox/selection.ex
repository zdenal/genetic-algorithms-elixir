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
end
