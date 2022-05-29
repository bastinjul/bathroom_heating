defmodule HomeAutomationWeb.PageController do
  use HomeAutomationWeb, :live_view
  require Logger

  alias HomeAutomation.HeatingManager
  alias Phoenix.PubSub

  def render(assigns) do
    Phoenix.View.render(HomeAutomationWeb.PageView, "index.html", assigns)
  end

  def mount(_params, _session, socket) do
    PubSub.subscribe(HomeAutomation.PubSub, "temperature:measurement")
    PubSub.subscribe(HomeAutomation.PubSub, "plug:status")
    plug_status = HeatingManager.get_plug_status()
    {:ok, assign(socket, temperature: :waiting_temp, plug_status: plug_status)}
  end

  def handle_info({:temp, temp}, socket) do
    {:noreply, assign(socket, :temperature, temp)}
  end

  def handle_info({:status, plug_status}, socket) do
    {:noreply, assign(socket, :plug_status, plug_status)}
  end

  def handle_info(message, socket) do
    Logger.debug "Got message : #{message}"
    {:noreply, socket}
  end

  def handle_event("plug_switch", _params, socket) do
    plug_status = HeatingManager.switch_plug()
    PubSub.broadcast(HomeAutomation.PubSub, "plug:status", {:status, plug_status})
    {:noreply, assign(socket, :plug_status, plug_status)}
  end
end
