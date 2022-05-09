defmodule HomeAutomationWeb.TemperatureController do
  use HomeAutomationWeb, :live_view

  alias HomeAutomation.TemperatureManager

  def render(assigns) do
    Phoenix.View.render(HomeAutomationWeb.TemperatureView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 5000)
    temperature = TemperatureManager.get_temperature()
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_info(:update, socket) do
    Process.send_after(self(), :update, 5000)
    temperature = TemperatureManager.get_temperature()
    {:noreply, assign(socket, :temperature, temperature)}
  end
end
