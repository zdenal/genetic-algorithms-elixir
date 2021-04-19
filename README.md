# Genetic Algorithms in Elixir
This is code is based on excellent book

**Genetic Algorithms in Elixir - Solve Problems Using Evolution (by Sean Moriarity)**
https://pragprog.com/titles/smgaelixir/genetic-algorithms-in-elixir/

<img src="https://pragprog.com/titles/smgaelixir/genetic-algorithms-in-elixir/smgaelixir.jpg" width=400 />

### Notes
*page 59*

why introducing `generation` variable increased each `evolve` call if by each `evaluate` call
is `age` of Chromosome increased. We could use it in `terminate` function instead of `generation`.

**page 67**

instead of mapping chromosome there should be chromosome.genes

*page 66* and so on before

in terminate? function is max_value calculated over population by fitness_function ... should have
1st chromosome in population best fitness value already?

**page 90**

bad barackets for `Enum.at/2`. Change from
```
|> Kernel.-(Enum.at(chromosome.genes), j)
```
to
```
|> Kernel.-(Enum.at(chromosome.genes, j))
```

*page 92*

why using `MapSet` if NQueens `genotype` is already generating uniq list of numbers? Isn't this easier?
```
    slice1 = Enum.slice(p1.genes, from..to)
    {head1, tail1} = (p2.genes -- slice1) |> Enum.split(from)
    .. head1 ++ slice1 ++ tail1 ..
```

**page 111**
`target` needs to be in double quotes for let it works in `String.jaro_distance(target, guess)`. Change from
```
target = 'ILoveGeneticAlgorithms'
```
to
```
target = "ILoveGeneticAlgorithms"
```

Compiler complains about cipher function. Change from
```
cipher = fn word, key -> Enum.map(word, rem(& &1 ^^^ key, 32768)) end
```
to
```
cipher = fn word, key -> Enum.map(word, &rem(&1 ^^^ key, 32768)) end
```

**page 132*
In `def elitist(parents, offspring, leftovers, survival_rate)` are parents list of tuples for `crossover` process.
In reinsertion we are handle them as list in `parents ++ lefovers` and working w/ them as normal list.

*page 134*
In code example is not `uniform` reinsertion executed as is described in text above.
