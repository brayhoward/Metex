alias Metex.{Coordinator, Worker}

defmodule Metex do
  def temperatures_of(cities) do
    args = [
      [],
      Enum.count(cities)
    ]

    cordinator_pid = spawn(Coordinator, :loop, args)

    cities |> Enum.each(fn city ->
      worker_pid = spawn(Worker, :loop, [])
      send worker_pid, {cordinator_pid, city}
    end)
  end
end
