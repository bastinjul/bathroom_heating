defmodule HomeAutomation.TemperaturePuller do
    use GenServer
    require Logger

    alias HomeAutomation.TemperatureManager
    alias Phoenix.PubSub

    @temperature_polling_interval System.get_env("TEMP_POLLING_TIME") |> String.to_integer

    @spec temperature_polling_interval :: Integer
    defp temperature_polling_interval, do: @temperature_polling_interval

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
        {:ok, temp} -> temp
        _ -> actual_temp
      end
      if new_temp != 0, do: PubSub.broadcast(HomeAutomation.PubSub, "temperature:measurement", {:temp, new_temp})
      schedule_work()
      {:noreply, {:temp, new_temp}}
    end

    defp schedule_work do
      Process.send_after(self(), :get_temp, temperature_polling_interval())
    end

end
