defmodule Utilities.Genealogy do
  use GenServer

  ### SERVER
  def init(_opts) do
    {:ok, Graph.new()}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def handle_cast({:add_chromosomes, chromosomes}, graph) do
    {:noreply, Graph.add_vertices(graph, chromosomes)}
  end

  # Child is mutant of Parent
  def handle_cast({:add_chromosome, parent, child}, graph) do
    new_graph =
      graph
      |> Graph.add_edge(parent, child)

    {:noreply, new_graph}
  end

  # Child is crossover of Parents
  def handle_cast({:add_chromosome, parent_a, parent_b, child}, graph) do
    new_graph =
      graph
      |> Graph.add_edge(parent_a, child)
      |> Graph.add_edge(parent_b, child)

    {:noreply, new_graph}
  end

  def handle_call(:get_tree, _, graph) do
    {:reply, graph, graph}
  end

  ### Client
  def add_chromosomes(chromosomes) do
    GenServer.cast(__MODULE__, {:add_chromosomes, chromosomes})
  end

  def add_chromosome(parent, child) do
    GenServer.cast(__MODULE__, {:add_chromosome, parent, child})
  end

  def add_chromosome(parent_a, parent_b, child) do
    GenServer.cast(__MODULE__, {:add_chromosome, parent_a, parent_b, child})
  end

  def get_tree do
    GenServer.call(__MODULE__, :get_tree)
  end
end
