defmodule Genetic do
  alias Types.Chromosome

  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0)

    population
    |> evolve(problem, 0, 0, opts)
  end

  def evolve(population, problem, last_best_fitness, temperature, opts \\ []) do
    [best | _] = population = evaluate(population, &problem.fitness_function/1)

    IO.puts("Current best: #{best.fitness}")

    temperature = 0.8 * (temperature + (best.fitness - last_best_fitness))

    if problem.terminate?(population, temperature) do
      best
    else
      {parents, leftover} = select(population, opts)
      children = crossover(parents, opts)

      (children ++ leftover)
      |> mutation(opts)
      |> evolve(problem, best.fitness, temperature, opts)

      # population
      # |> select(opts)
      # |> crossover(opts)
      # |> mutation(opts)
      # |> evolve(problem, best.fitness, temperature, opts)
    end
  end

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  def evaluate(population, fitness_function, _opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      %Chromosome{chromosome | fitness: fitness_function.(chromosome), age: chromosome.age + 1}
    end)
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  def select(population, opts \\ []) do
    select_fn = Keyword.get(opts, :selection_type, &Toolbox.Selection.elite/2)
    select_rate = Keyword.get(opts, :selection_rate, 0.8)

    split = round(length(population) * select_rate)
    count = if rem(split, 2) == 0, do: split, else: split + 1

    parents = select_fn |> apply([population, count])

    leftover =
      population
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(parents))
      |> MapSet.to_list()

    parents =
      parents
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple(&1))

    {parents, leftover}
  end

  def crossover(population, opts \\ []) do
    crossover_fn = Keyword.get(opts, :crossover_type, &Toolbox.Crossover.order_one/2)

    population
    |> Enum.reduce(
      [],
      fn {p1, p2}, acc ->
        {child1, child2} = apply(crossover_fn, [p1, p2])
        [child1, child2 | acc]
      end
    )
    |> Enum.map(&repair_chromosome/1)
  end

  def mutation(population, opts \\ []) do
    mutate_fn = Keyword.get(opts, :mutation_type, &Toolbox.Mutation.scrable/1)
    rate = Keyword.get(opts, :mutation_rate, 0.05)

    population
    |> Enum.map(fn chromosome ->
      if :rand.uniform() < rate do
        apply(mutate_fn, [chromosome])
      else
        chromosome
      end
    end)
  end

  defp repair_chromosome(chromosome) do
    # One approach that works around limitations in crossover strategies is the
    # concept of chromosome repairment. Chromosome repairment is the process
    # of ensuring solutions remain valid after crossover or mutation. In the case of
    # N-queens, using single-point crossover ruins the integrity of the permutation.
    # This means after crossover takes place, you have to go in and individually
    # repair every chromosome.
    #
    # genes = MapSet.new(chromosome.genes)
    # new_genes = repair_helper(chromosome, 8)
    # %Chromosome{chromosome | genes: new_genes}
    chromosome
  end

  defp repair_helper(chromosome, k) do
    if MapSet.size(chromosome) >= k do
      MapSet.to_list(chromosome)
    else
      num = :rand.uniform(8)
      repair_helper(MapSet.put(chromosome, num), k)
    end
  end
end
