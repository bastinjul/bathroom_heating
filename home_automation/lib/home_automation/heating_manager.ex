defmodule HomeAutomation.HeatingManager do
  @moduledoc """
  The HeatingManager context.
  """

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
end
