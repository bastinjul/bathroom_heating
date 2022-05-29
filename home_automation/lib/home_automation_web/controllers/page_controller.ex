defmodule HomeAutomationWeb.PageController do
  use HomeAutomationWeb, :live_view
  require Logger

  alias HomeAutomation.HeatingManager
  alias HomeAutomation.TemperatureManager
  alias Phoenix.PubSub

  @temperature_polling_interval System.get_env("TEMP_POLLING_TIME") |> String.to_integer

  @spec temperature_polling_interval :: Integer
  defp temperature_polling_interval, do: @temperature_polling_interval

  def render(assigns) do
    Phoenix.View.render(HomeAutomationWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    PubSub.subscribe(HomeAutomation.PubSub, "temperature:measurement")
    plug_status = HeatingManager.get_plug_status()
    {:ok, assign(socket, temperature: :waiting_temp, plug_status: plug_status)}
  end

  def handle_info({:temp, temp}, socket) do
    Logger.debug "Got temperature: #{temp}"
    {:noreply, assign(socket, :temperature, temp)}
  end

  def handle_info(message, socket) do
    Logger.debug "Got message : #{message}"
    {:noreply, socket}
  end

  def handle_event("plug_switch", _params, socket) do
    plug_status = HeatingManager.switch_plug()
    {:noreply, assign(socket, :plug_status, plug_status)}
  end
end
