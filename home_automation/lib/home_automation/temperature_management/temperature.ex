defmodule HomeAutomation.TemperatureManager.Temperature do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias HomeAutomation.Repo

  schema "temperatures" do
    field :temperature, :float

    timestamps()
  end

  @doc false
  def changeset(temperature, attrs) do
    temperature
    |> cast(attrs, [:temperature])
    |> validate_required([:temperature])
  end
  
  def get_most_recent_temperature() do
    query = from t in HomeAutomation.TemperatureManager.Temperature, select: t.temperature, order_by: [desc: t.inserted_at]
    query |> first |> Repo.one
  end

end
