defmodule HomeAutomation.PlugActivatorManager do
  use GenServer
  require Logger

  alias Phoenix.PubSub

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_) do
    PubSub.subscribe(HomeAutomation.PubSub, "plug:activation")
    {:ok, %{}}
  end

  @impl true
  def handle_info({:day, day, :wake_up_time, wake_up_time}, _state) do
    #TODO: implement logic of plug activation/deactivation
    #TODO: retrieve TEMP_GOAL and compare it with actual temperature (check last inserted value in DB)
    #TODO: if actual_temp < TEMP_GOAL : activate the plug if it's not yet activated. Else : deactivate the plug if it's not yet off.
    #TODO: Make the previous check every minute
    #TODO: perform the whole job until wake_up_time + MINUTES_AFTER_WAKE_UP
    {:noreply, %{:day => day, :wake_up_time => wake_up_time}}
  end

end
