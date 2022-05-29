defmodule HomeAutomation.TemperaturePuller do
    use GenServer
    require Logger

    alias HomeAutomation.TemperatureManager
    alias Phoenix.PubSub

    def start_link(_) do
      GenServer.start_link(__MODULE__, %{})
    end

    @impl true
    def init(_) do
      schedule_work()
      {:ok, {:temp, 0}}
    end

    @impl true
    def handle_info(:get_temp,{:temp, actual_temp}) do
      new_temp = case TemperatureManager.get_temperature() do
        {:ok, temp} ->
            PubSub.broadcast(HomeAutomation.PubSub, "temperature:measurement", {:temp, temp})
            temp
        _ -> actual_temp
      end
      schedule_work()
      {:noreply, {:temp, new_temp}}
    end

    defp schedule_work do
      Process.send_after(self(), :get_temp, 1000 * 10)
    end

end
