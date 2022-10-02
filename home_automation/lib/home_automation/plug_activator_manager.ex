defmodule HomeAutomation.PlugActivatorManager do
  @moduledoc """
  Module that handles the gestion of the plug activation based on the temperature of desired temperature
    and the wake-up time
  """

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_) do
    schedule_work()
    {:ok}
  end

  def handle_info(:check_activation, _) do

  end

  defp schedule_work do
    Process.send_after(self(), :check_activation, 10000)
  end
  
end
