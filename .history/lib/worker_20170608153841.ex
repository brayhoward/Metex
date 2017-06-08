defmodule Metex.Worker do

  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get |> parse_response

    case result do
      {:ok, temp} ->
        "#{location}: #{temp}°F"
      :error ->
        "Location #{location} not found"
    end
  end

  def url_for location do
    location = URI.encode(location)

    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=12167dc2b6f421ee44367e4d20feeec8"
  end

  #
  ## Parse response
  #
  defp parse_response({:ok, %HTTPoison.Response{ body: body, status_code: 200 }}) do

    body
    |> JSON.decode!
    |> compute_temperature
  end

  defp parse_response(_), do: :error

  defp compute_temperature(json) do

    try do
      # Convert temp form Kelvin to Fahrenheit
      fahrenheit = (json["main"]["temp"] * (9/5)) - 495.67 |> Float.round(1)

      {:ok, fahrenheit}

    rescue
      _ -> :error
    end
  end
end