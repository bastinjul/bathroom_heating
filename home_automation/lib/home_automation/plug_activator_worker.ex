defmodule HomeAutomation.PlugActivatorWorker do
  use Oban.Worker,
      queue: :calendar_wake_up_plug_activation,
      max_attempts: 1,
      tags: ["plug_activator"],
      unique: [period: :infinity, fields: [:args], keys: [:day]]

  alias Phoenix.PubSub
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"day" => day,"wake_up_time" => wake_up_time} = _args}) do
    Logger.info "Worker activated. Sending day = #{day} and wake_up_time = #{wake_up_time} to pubsub topic plug:activation"

    PubSub.broadcast(HomeAutomation.PubSub, "plug:activation", {:start_plug_management, {:day, Date.from_iso8601!(day), :wake_up_time, Time.from_iso8601!(wake_up_time)}})
    :ok
  end
  
end
