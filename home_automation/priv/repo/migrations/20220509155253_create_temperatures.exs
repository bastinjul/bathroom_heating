defmodule HomeAutomation.Repo.Migrations.CreateTemperatures do
  use Ecto.Migration

  def change do
    create table(:temperatures) do
      add :temperature, :float

      timestamps()
    end
  end
end
