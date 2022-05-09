defmodule HomeAutomation.HeatingManager.Calendar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calendar" do
    field :day, :date
    field :wake_up_time, :time

    timestamps()
  end

  @doc false
  def changeset(calendar, attrs) do
    calendar
    |> cast(attrs, [:day, :wake_up_time])
    |> validate_required([:day, :wake_up_time])
  end
end
