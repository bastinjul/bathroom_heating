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
        temp = decode_body(response.body)
        Logger.debug "Got temperature: #{temp}"
        {:ok, temp}
      _ ->
        Logger.error "Failed to get temperature"
        :error
    end
  end

  def decode_body(body) when is_map(body) do
    %{"data" => temp, "sensor" => "temp"} = body
    temp
  end

  def decode_body(body) do
    {:ok, %{"data" => temp, "sensor" => "temp"}} = Jason.decode(body)
    temp
  end

end
