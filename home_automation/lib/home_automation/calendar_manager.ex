defmodule HomeAutomation.CalendarManager do
  @moduledoc false

  import Ecto.Query, warn: false
  alias HomeAutomation.Repo
  alias HomeAutomation.HeatingManager.Calendar

  @doc """
  Insert a calendar entry
  """
  def insert_calendar(attrs \\ %{}) do
    %Calendar{}
    |> Calendar.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Update the wake-up time for the given day
  """
  def modify_calendar(day, new_time) do
    Calendar.update_wake_up_time(day, new_time)
  end

  @spec get_wake_up_time(day :: Calendar.date()) :: {integer(), Calendar.date(), Calendar.time()}
  def get_wake_up_time(day) do
    Calendar.get_wake_up_time(day)
  end

end
