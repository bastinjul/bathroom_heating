defmodule HomeAutomation.Config do
  use Ecto.Schema
  import Ecto.Changeset

  schema "configs" do
    field :label, :string
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(config, attrs) do
    config
    |> cast(attrs, [:label, :value])
    |> validate_required([:label, :value])
    |> unique_constraint(:label)
  end
end
