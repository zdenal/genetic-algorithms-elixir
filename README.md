# Genetic Algorithms in Elixir
This is code is based on excellent book

**Genetic Algorithms in Elixir - Solve Problems Using Evolution (by Sean Moriarity)**
https://pragprog.com/titles/smgaelixir/genetic-algorithms-in-elixir/

<img src="https://pragprog.com/titles/smgaelixir/genetic-algorithms-in-elixir/smgaelixir.jpg" width=400 />

### Notes
*page 59*

why introducing `generation` variable increased each `evolve` call if by each `evaluate` call
is `age` of Chromosome increased. We could use it in `terminate` function instead of `generation`.

*page 67*

instead of mapping chromosome the should be chromosome.genes

*page 66* and so on before

in terminate? function is max_value calculated over population by fitness_function ... should have
1st chromosome in population best fitness value already?

*page 90*

bad barackets for `Enum.at/2` in `|> Kernel.-(Enum.at(chromosome.genes), j)` -> `|> Kernel.-(Enum.at(chromosome.genes, j))`

*page 92*

why using `MapSet` if NQueens `genotype` is already generating uniq list of numbers? Isn't this easier?
```
    slice1 = Enum.slice(p1.genes, from..to)
    {head1, tail1} = (p2.genes -- slice1) |> Enum.split(from)
    .. head1 ++ slice1 ++ tail1 ..
```
