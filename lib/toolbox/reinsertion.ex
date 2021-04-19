# Reinsertion is the process of taking chromosomes produced from selection,
# crossover, and mutation and inserting them back into a population to move
# on to the next generation.
#
defmodule Toolbox.Reinsertion do
  def pure(_parents, offspring, _leftover) do
    # Pure reinsertion maintains none of the strengths of the old population and
    # instead relies on the ability of selection, crossover, and mutation to form a
    # report erratum
    # stronger population. Pure reinsertion is fast, but you could potentially eliminate
    # some of your stronger characteristics in a population as a result.
    offspring
  end

  def elitist(parents, offspring, leftover, survival_rate) do
    # Probably the most common reinsertion strategy. It’s
    # reasonably fast with small populations, and it works well because it preserves
    # the strengths of your old population.
    # Elitist reinsertion or elitist replacement is a type of reinsertion strategy in which
    # you keep a top-portion of your old population to survive to the next generation.
    # With this strategy, you introduce the notion of a survival rate. The survival
    # rate dictates the percentage of parent chromosomes that survive to the next
    # generation. With a population of 100 and a survival rate of 20% or 0.2, you’d
    # keep the top 20% of your parents.
    # One thing to consider with elitist reinsertion is how survival rate affects your
    # population size.
    prev_population = parents ++ leftover
    n = floor(length(prev_population) * survival_rate)

    survivors =
      prev_population
      |> Enum.sort_by(& &1.fitness, &>=/2)
      |> Enum.take(n)

    offspring ++ survivors
  end

  def uniform(parents, offspring, leftover, survival_rate) do
    # Uniform reinsertion or random replacement is a reinsertion strategy that
    # selects random chromosomes from the old population to survive to the next
    # generation. The purpose of uniform reinsertion is to maintain as much
    # genetic diversity as possible in the new population. Uniform reinsertion isn’t
    # very common, but it’s worth trying to see what happens.
    prev_population = parents ++ leftover
    n = floor(length(prev_population) * survival_rate)

    survivors =
      prev_population
      |> Enum.take_random(n)

    offspring ++ survivors
  end
end
