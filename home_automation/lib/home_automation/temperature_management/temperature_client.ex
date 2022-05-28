defmodule HomeAutomation.TemperatureManager.TemperatureClient do
  require Logger
  use Tesla

  plug Tesla.Middleware.BaseUrl, System.get_env("TEMP_URL")
  plug Tesla.Middleware.JSON

  @spec get_temperature :: float | :error
  @doc """
  Get the temperature from the temperature sensor.
  """
  def get_temperature() do
    Logger.debug "Getting temperature"
    case get("") do
      {:ok, response} ->
        Logger.debug "Got temperature: #{response.body}"
        {:ok, %{"data" => temp, "sensor" => "temp"}} = Jason.decode(response.body)
        Logger.debug "Decoded temperature: #{temp}"
        temp
      _ ->
        :error
    end
  end

end
