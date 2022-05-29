defmodule HomeAutomation.TemperatureManager.TemperatureClient do
  require Logger
  use Tesla

  plug Tesla.Middleware.BaseUrl, System.get_env("TEMP_URL")
  plug Tesla.Middleware.JSON

  @spec get_temperature :: {:ok, float} | :error
  @doc """
  Get the temperature from the temperature sensor.
  """
  def get_temperature() do
    Logger.debug "Getting temperature"
    case get("") do
      {:ok, response} ->
        {:ok, %{"data" => temp, "sensor" => "temp"}} = Jason.decode(response.body)
        Logger.debug "Got temperature: #{temp}"
        {:ok, temp}
      _ ->
        Logger.error "Failed to get temperature"
        :error
    end
  end

end
