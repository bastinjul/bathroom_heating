defmodule HomeAutomationWeb.TemperatureController do
  use HomeAutomationWeb, :live_view

  alias HomeAutomation.TemperatureManager

  @temperature_polling_interval System.get_env("TEMP_POLLING_TIME") |> String.to_integer

  @spec temperature_polling_interval :: Integer
  defp temperature_polling_interval, do: @temperature_polling_interval

  def render(assigns) do
    Phoenix.View.render(HomeAutomationWeb.TemperatureView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, temperature_polling_interval())
    temperature = TemperatureManager.get_temperature()
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, temperature_polling_interval())
    temperature = TemperatureManager.get_temperature()
    {:noreply, assign(socket, :temperature, temperature)}
  end
end
