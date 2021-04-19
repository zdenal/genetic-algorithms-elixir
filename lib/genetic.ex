defmodule Genetic do
  alias Types.Chromosome

  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0)

    population
    |> evolve(problem, 0, 0, opts)
  end

  def evolve(population, problem, last_best_fitness, temperature, opts \\ []) do
    [best | _] = population = evaluate(population, &problem.fitness_function/1)
    statistics(population, opts)

    IO.puts("Current best: #{best.fitness}, Current age: #{best.age}")

    temperature = 0.8 * (temperature + (best.fitness - last_best_fitness))

    if problem.terminate?(population, temperature) do
      best
    else
      {parents, leftover} = select(population, opts)
      children = crossover(parents, opts)
      mutants = mutation(population, opts)
      offspring = children ++ mutants

      new_population = reinsertion(parents, offspring, leftover, opts)

      evolve(new_population, problem, best.fitness, temperature, opts)

      # population
      # |> select(opts)
      # |> crossover(opts)
      # |> mutation(opts)
      # |> evolve(problem, best.fitness, temperature, opts)
    end
  end

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    population = for _ <- 1..population_size, do: genotype.()
    Utilities.Genealogy.add_chromosomes(population)
    population
  end

  def evaluate(population, fitness_function, _opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      %Chromosome{chromosome | fitness: fitness_function.(chromosome), age: chromosome.age + 1}
    end)
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  def statistics(population, opts \\ []) do
    default_stats = [
      min_fitness: &Enum.min_by(&1, fn c -> c.fitness end).fitness,
      max_fitness: &Enum.max_by(&1, fn c -> c.fitness end).fitness,
      mean_fitness: &(Enum.sum(Enum.map(&1, fn c -> c.fitness end)) / length(&1))
    ]

    stats = Keyword.get(opts, :statistics, default_stats)

    stats_map =
      stats
      |> Enum.reduce(
        %{},
        fn {key, func}, acc ->
          Map.put(acc, key, func.(population))
        end
      )

    [%{age: generation} | _] = population

    Utilities.Statistics.insert(generation, stats_map)
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

  def crossover(selected_parents, opts \\ []) do
    crossover_fn = Keyword.get(opts, :crossover_type, &Toolbox.Crossover.single_point/2)

    selected_parents
    |> Enum.reduce(
      [],
      fn {p1, p2}, acc ->
        {child1, child2} = apply(crossover_fn, [p1, p2])
        Utilities.Genealogy.add_chromosome(p1, p2, child1)
        Utilities.Genealogy.add_chromosome(p1, p2, child2)
        [child1, child2 | acc]
      end
    )
    |> Enum.map(&repair_chromosome/1)
  end

  def mutation(population, opts \\ []) do
    mutate_fn = Keyword.get(opts, :mutation_type, &Toolbox.Mutation.scrable/1)
    rate = Keyword.get(opts, :mutation_rate, 0.05)

    n = floor(length(population) * rate)

    population
    |> Enum.take(n)
    |> Enum.map(fn parent ->
      mutant = apply(mutate_fn, [parent])
      Utilities.Genealogy.add_chromosome(parent, mutant)
      mutant
    end)
  end

  def reinsertion(parents, offspring, leftover, opts \\ []) do
    strategy = Keyword.get(opts, :reinsertion_strategy, &Toolbox.Reinsertion.pure/3)
    parents_as_list = parents |> Enum.flat_map(&Tuple.to_list/1)

    apply(strategy, [parents_as_list, offspring, leftover])
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
