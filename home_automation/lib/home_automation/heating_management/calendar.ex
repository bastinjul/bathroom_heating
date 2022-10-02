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
  @spec get_wake_up_time(day :: Calendar.date()) :: %HomeAutomation.HeatingManager.Calendar{}
  def get_wake_up_time(day) do
    query = from c in HomeAutomation.HeatingManager.Calendar, where: c.day == ^day
    Repo.one(query)
  end

  @doc """
  Update the wake-up-time for the given day
  """
  @spec update_wake_up_time(day :: Calendar.date(), new_time :: Calendar.time()) :: any()
  def update_wake_up_time(day, new_time) do
    {1, _} =
      from(c in HomeAutomation.HeatingManager.Calendar, where: c.day == ^day, select: c)
      |> Repo.update_all(set: [wake_up_time: new_time])
  end

  @doc """
  Delete the line with the given day
  """
  @spec delete_wake_up_date(day :: Calendar.date()) :: any()
  def delete_wake_up_date(day) do
    _ =
      from(c in HomeAutomation.HeatingManager.Calendar, where: c.day == ^day, select: c)
      |> Repo.delete_all
  end

  defp create_query(days) do
    from c in HomeAutomation.HeatingManager.Calendar, where: c.day in ^days, select: {c.day, c.wake_up_time}
  end
end
