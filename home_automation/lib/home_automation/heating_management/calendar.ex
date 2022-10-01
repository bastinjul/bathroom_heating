defmodule HomeAutomation.HeatingManager.Calendar do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias HomeAutomation.Repo

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

  @doc """
  return a map with all wake-up-time corresponding to the days
  """
  @spec wake_up_days_of_month(days :: list()) :: list()
  def wake_up_days_of_month(days) do
    Repo.all(create_query(days))
  end

  @doc """
  Get the information about the wake up time for the given day
  """
  @spec get_wake_up_time(day :: Calendar.date()) :: {Calendar.date(), Calendar.time()}
  def get_wake_up_time(day) do
    query = from c in HomeAutomation.HeatingManager.Calendar, where: c.day == ^day, select: {c.day, c.wake_up_time}
  end

  defp create_query(days) do
    from c in HomeAutomation.HeatingManager.Calendar, where: c.day in ^days, select: {c.day, c.wake_up_time}
  end
end
