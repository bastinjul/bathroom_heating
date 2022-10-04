defmodule HomeAutomation.PlugActivatorWorker do
  use Oban.Worker,
      queue: :calendar_wake_up_plug_activation,
      max_attempts: 1,
      tags: ["plug_activator"],
      unique: [period: :infinity, fields: [:args], keys: [:day]]

  alias Phoenix.PubSub

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"day" => day,"wake_up_time" => wake_up_time} = _args}) do
    PubSub.broadcast(HomeAutomation.PubSub, "plug:activation", {:start_plug_management, {:day, day, :wake_up_time, wake_up_time}})
    :ok
  end
  
end
