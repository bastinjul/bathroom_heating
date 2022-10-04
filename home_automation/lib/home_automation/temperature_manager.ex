defmodule HomeAutomation.TemperatureManager do
  @moduledoc """
  The TemperatureManager context.
  """

  import Ecto.Query, warn: false
  alias HomeAutomation.Repo

  alias HomeAutomation.TemperatureManager.Temperature
  alias HomeAutomation.TemperatureManager.TemperatureClient

  @doc """
  Insert a temperature data.
  """
  def insert_temperature(attrs \\ %{}) do
    %Temperature{}
    |> Temperature.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_temperature :: {:ok, float} | :error
  @doc """
  Get the temperature from the temperature sensor.
  """
  def get_temperature() do
    TemperatureClient.get_temperature()
  end

  def get_most_recent_temperature() do

  end
end
