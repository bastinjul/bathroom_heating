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
    Logger.info "Start Module that handles plug activation."
    PubSub.subscribe(HomeAutomation.PubSub, "plug:activation")
    {:ok, %{}}
  end

  @impl true
  def handle_info({:start_plug_management, {:day, day, :wake_up_time, wake_up_time}}, _state) do
    now = Timex.now("Europe/Brussels")
    stop_time = get_stop_time(day, wake_up_time)
    Logger.info "Start plug management at #{now}. Stop time = #{stop_time}"
    if Timex.after?(now, stop_time) do
      turn_off_plug()
    else
      schedule_work(0)
      {:noreply, %{:day => day, :wake_up_time => wake_up_time}}
    end
  end

  @impl true
  def handle_info(:plug_management, %{:day => day, :wake_up_time => wake_up_time}) do
    if Timex.after?(Timex.now("Europe/Brussels"), get_stop_time(day, wake_up_time)) do
      turn_off_plug()
    else
      try do
        {temp_goal, _} = Float.parse(ConfigManager.get_temp_goal())
        if temp_goal <= TemperatureManager.get_most_recent_temperature() do
          PlugClient.turn_off_plug()
        else
          PlugClient.turn_on_plug()
        end
      rescue
        _ -> Logger.error "Impossible to turn of plug"
      end
      schedule_work(@interval_millisec)
      {:noreply, %{:day => day, :wake_up_time => wake_up_time}}
    end
  end

  defp schedule_work(interval) do
    Process.send_after(self(), :plug_management, interval)
  end

  defp get_stop_time(day, wake_up_time) do
    DateTime.new!(day, wake_up_time, "Europe/Brussels", Timex.Timezone.Database)
    |> Timex.add(Timex.Duration.from_minutes(String.to_integer(ConfigManager.get_minutes_after_wake_up())))
  end

  defp turn_off_plug() do
    try do
      PlugClient.turn_off_plug()
    rescue
      _ -> Logger.error "Impossible to turn of plug"
    after
      {:noreply, %{}}
    end
  end

end
