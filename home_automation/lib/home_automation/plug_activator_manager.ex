defmodule HomeAutomation.PlugActivatorManager do
  use GenServer
  require Logger

  alias HomeAutomation.ConfigManager
  alias HomeAutomation.TemperatureManager
  alias HomeAutomation.HeatingManager.PlugClient
  alias Phoenix.PubSub

  @interval_millisec 60000

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    PubSub.subscribe(HomeAutomation.PubSub, "plug:activation")
    {:ok, %{}}
  end

  @impl true
  def handle_info({:start_plug_management, {:day, day, :wake_up_time, wake_up_time}}, _state) do
    if Timex.after?(Timex.now("Europe/Brussels"), get_stop_time(day, wake_up_time)) do
      {:noreply, %{}}
    else
      schedule_work()
      {:noreply, %{:day => day, :wake_up_time => wake_up_time}}
    end
  end

  @impl true
  def handle_info(:plug_management, %{:day => day, :wake_up_time => wake_up_time}) do
    if Timex.after?(Timex.now("Europe/Brussels"), get_stop_time(day, wake_up_time)) do
      {:noreply, %{}}
    else
      if ConfigManager.get_temp_goal() <= TemperatureManager.get_most_recent_temperature()do
        PlugClient.turn_off_plug()
      else
        PlugClient.turn_on_plug()
      end
      schedule_work()
      {:noreply, %{:day => day, :wake_up_time => wake_up_time}}
    end
  end

  defp schedule_work do
    Process.send_after(self(), :plug_management, @interval_millisec)
  end

  defp get_stop_time(day, wake_up_time) do
    DateTime.new!(day, wake_up_time, "Europe/Brussels", Timex.Timezone.Database)
    |> Timex.add(Timex.Duration.from_minutes(Integer.parse(ConfigManager.get_minutes_after_wake_up())))
  end

end
