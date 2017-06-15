alias Metex.{Coordinator, Worker}

defmodule Metex do
  def temperatures_of(cities) do
    results_expected = Enum.count(cities)
    cordinator_pid = spawn(Coordinator, :loop, [results_expected])

    cities |> Enum.each(fn city ->
      # TODO: reason about why this is so 👇
      # Move the next line above the each block and the program slows significantly.
      worker_pid = spawn(Worker, :loop, [])
      send worker_pid, {cordinator_pid, city}
    end)
  end
end
