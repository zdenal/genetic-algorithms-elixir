# mix run scripts/schedule.exs

defmodule Class do
  defstruct [:name, :hours, :difficulty, :usefullnes, :interest]
end

defmodule Classes do
  @classes [
    %Class{name: "Algorithms", hours: 3.0, difficulty: 8.0, usefullnes: 8.0, interest: 8.0},
    %Class{
      name: "Artificial Intelligence",
      hours: 3.0,
      difficulty: 9.0,
      usefullnes: 9.0,
      interest: 8.0
    },
    %Class{name: "Calculus", hours: 3.0, difficulty: 4.0, usefullnes: 6.0, interest: 5.0},
    %Class{name: "Chemistry", hours: 4.5, difficulty: 3.0, usefullnes: 2.0, interest: 9.0},
    %Class{
      name: "Data Structures",
      hours: 3.0,
      difficulty: 5.0,
      usefullnes: 8.0,
      interest: 7.0
    },
    %Class{
      name: "Discrete Math",
      hours: 3.0,
      difficulty: 2.0,
      usefullnes: 9.0,
      interest: 2.0
    },
    %Class{name: "History", hours: 3.0, difficulty: 4.0, usefullnes: 1.0, interest: 8.0},
    %Class{name: "Literature", hours: 3.0, difficulty: 2.0, usefullnes: 2.0, interest: 2.0},
    %Class{name: "Physics", hours: 4.5, difficulty: 6.0, usefullnes: 5.0, interest: 7.0},
    %Class{name: "Volleyball", hours: 1.5, difficulty: 1.0, usefullnes: 1.0, interest: 10.0}
  ]

  def get_by_attr(attr), do: Enum.map(@classes, &Map.get(&1, attr))
end

defmodule Schedule do
  @behaviour Problem

  alias Types.Chromosome

  @size 10

  @impl Problem
  def genotype do
    # Class presented in schedule has 1. Not presented has 0. Classes are presented in genes by their index in Class.classes/0
    genes = for _ <- 1..@size, do: Enum.random(1..0)
    %Chromosome{genes: genes, size: @size}
  end

  @impl Problem
  def fitness_function(%Chromosome{genes: schedule}) do
    # Weigh each criteria evenly, so difficulty, usefulness, and
    # interest are all worth 33% of a class’s final rating. You can use each of these
    # weights to calculate the fitness of each schedule as a sum of each weighted
    # criteria
    fitness =
      [
        schedule,
        Classes.get_by_attr(:difficulty),
        Classes.get_by_attr(:usefullnes),
        Classes.get_by_attr(:interest)
      ]
      |> Enum.zip()
      |> Enum.map(fn {scheduled, diff, usefull, int} ->
        scheduled * (0.33 * diff + 0.33 * usefull + 0.33 * int)
      end)
      |> Enum.sum()

    credit =
      schedule
      |> Enum.zip(Classes.get_by_attr(:hours))
      |> Enum.map(fn {presented, hours} -> presented * hours end)
      |> Enum.sum()

    # We can have only 18 hours of classes. Because it’s possible for a schedule
    # to be rated negatively, we want penalty to be a really large negative
    # value, like -99999.
    if credit > 18, do: -9999, else: fitness
  end

  @impl Problem
  def terminate?([%Chromosome{age: age} | _], _temperature), do: age == 1_000
end

soln =
  Genetic.run(Schedule,
    crossover_type: &Toolbox.Crossover.order_one/2,
    reinsertion_strategy: &Toolbox.Reinsertion.elitist(&1, &2, &3, 0.1)
  )

IO.write("\n")
IO.inspect(soln)
IO.write("Credit\n")

soln.genes
|> Enum.zip(Classes.get_by_attr(:hours))
|> Enum.map(fn {presented, hours} -> presented * hours end)
|> Enum.sum()
|> IO.inspect()
