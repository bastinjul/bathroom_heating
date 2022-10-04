defmodule ConfigField do
  defstruct [:label, :value, :id, modif: false]
end

defmodule HomeAutomationWeb.PageLive do
  use HomeAutomationWeb, :live_view
  require Logger

  alias HomeAutomation.HeatingManager
  alias HomeAutomation.ConfigManager
  alias Phoenix.PubSub

  @impl true
  def render(assigns) do
    Phoenix.View.render(HomeAutomationWeb.PageView, "index.html", assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    PubSub.subscribe(HomeAutomation.PubSub, "temperature:measurement")
    PubSub.subscribe(HomeAutomation.PubSub, "plug:status")
    plug_status = HeatingManager.get_plug_status()
    temp_goal = ConfigManager.get_temp_goal()
    before_wake_up = ConfigManager.get_minutes_before_wake_up()
    after_wake_up = ConfigManager.get_minutes_after_wake_up()
    assigns = [
      temperature: :waiting_temp,
      plug_status: plug_status,
      before_wake_up: before_wake_up,
      after_wake_up: after_wake_up,
      temp_goal: temp_goal,
      config_modifs:
        %{
          before_wake_up: %ConfigField{label: "Before wake-up time : ", value: before_wake_up, id: :before_wake_up},
          after_wake_up: %ConfigField{label:  "After wake-up time : ", value: after_wake_up, id: :after_wake_up},
          temp_goal: %ConfigField{label: "Temperature goal : ", value: temp_goal, id: :temp_goal}
         }
    ]
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_info({:temp, temp}, socket) do
    {:noreply, assign(socket, :temperature, temp)}
  end

  @impl true
  def handle_info({:status, plug_status}, socket) do
    {:noreply, assign(socket, :plug_status, plug_status)}
  end

  @impl true
  def handle_info(message, socket) do
    Logger.debug "Got message : #{message}"
    {:noreply, socket}
  end

  @impl true
  def handle_event("plug_switch", _params, socket) do
    plug_status = HeatingManager.switch_plug()
    PubSub.broadcast(HomeAutomation.PubSub, "plug:status", {:status, plug_status})
    {:noreply, assign(socket, :plug_status, plug_status)}
  end

  @impl true
  def handle_event("modif-config", _param, socket) do
    {:noreply, push_patch(socket, to: "/config")}
  end

  @impl true
  def handle_event("close_modal", _, socket) do

    # Go back to the :index live action
    {:noreply, push_patch(socket, to: "/")}
  end

  @impl true
  def handle_event("before_wake_up", %{"temp_config" => %{"before_wake_up" => new_minutes}}, socket) do
    ConfigManager.update_minutes_before_wake_up(new_minutes)
    assigns = [
      before_wake_up: new_minutes,
      config_modifs: %{socket.assigns.config_modifs | before_wake_up: %{socket.assigns.config_modifs.before_wake_up | value: new_minutes, modif: false}}
    ]
    {:noreply,push_patch(assign(socket, assigns), to: "/")}
  end

  @impl true
  def handle_event("after_wake_up", %{"temp_config" => %{"after_wake_up" => new_minutes}}, socket) do
    ConfigManager.update_minutes_after_wake_up(new_minutes)
    assigns = [
      after_wake_up: new_minutes,
      config_modifs: %{socket.assigns.config_modifs | after_wake_up: %{socket.assigns.config_modifs.after_wake_up | value: new_minutes, modif: false}}
    ]
    {:noreply,push_patch(assign(socket, assigns), to: "/")}
  end

  @impl true
  def handle_event("temp_goal", %{"temp_config" => %{"temp_goal" => new_temp}}, socket) do
    ConfigManager.update_temp_goal(new_temp)
    assigns = [
      temp_goal: new_temp,
      config_modifs: %{socket.assigns.config_modifs | temp_goal: %{socket.assigns.config_modifs.temp_goal | value: new_temp, modif: false}}
    ]
    {:noreply,push_patch(assign(socket, assigns), to: "/")}
  end

  @impl true
  def handle_event("modify", %{"field" => "before_wake_up"}, socket) do
    assigns = [
      config_modifs: %{socket.assigns.config_modifs | before_wake_up: %{socket.assigns.config_modifs.before_wake_up | modif: true}}
    ]
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("modify", %{"field" => "after_wake_up"}, socket) do
    assigns = [
      config_modifs: %{socket.assigns.config_modifs | after_wake_up: %{socket.assigns.config_modifs.after_wake_up | modif: true}}
    ]
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("modify", %{"field" => "temp_goal"}, socket) do
    assigns = [
      config_modifs: %{socket.assigns.config_modifs | temp_goal: %{socket.assigns.config_modifs.temp_goal | modif: true}}
    ]
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
