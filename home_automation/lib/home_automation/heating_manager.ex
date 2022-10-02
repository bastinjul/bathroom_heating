defmodule HomeAutomation.HeatingManager do
  @moduledoc """
  The HeatingManager context.
  """

  import Ecto.Query, warn: false
  alias HomeAutomation.Repo

  alias HomeAutomation.HeatingManager.Calendar
  alias HomeAutomation.HeatingManager.PlugClient

  @doc """
  Get the list of wake-up time for the days passed as argument
  """
  @spec wake_up_days_of_month(days :: list()) :: map()
  def wake_up_days_of_month(days) do
    Enum.into(Calendar.wake_up_days_of_month(days), %{})
  end

  @doc """
  Switch the plug on or off depending on its status
  """
  def switch_plug() do
    plug_status = PlugClient.get_plug_status()
    if plug_status do
      PlugClient.turn_off_plug()
    else
      PlugClient.turn_on_plug()
    end
  end

  @doc """
  Get the plug status
  """
  def get_plug_status() do
    PlugClient.get_plug_status()
  end

end
