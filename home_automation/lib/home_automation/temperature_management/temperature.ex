defmodule HomeAutomation.TemperatureManager.Temperature do
  use Ecto.Schema
  import Ecto.Changeset

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

end
