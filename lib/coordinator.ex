defmodule Metex.Coordinator do
  def loop(results_expected, results \\ []) do
    receive do
      {:ok, result} ->
        new_results = [result | results]

        if results_expected == Enum.count(new_results) do
          send(self(), :exit)
        end
        loop(results_expected, new_results)

      :exit ->
        IO.puts(results |> Enum.sort |> Enum.join(",\n "))

      _ ->
        loop(results_expected, results)
    end
  end
end