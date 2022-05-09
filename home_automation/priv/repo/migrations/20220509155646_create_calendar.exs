defmodule HomeAutomation.Repo.Migrations.CreateCalendar do
  use Ecto.Migration

  def change do
    create table(:calendar) do
      add :day, :date
      add :wake_up_time, :time

      timestamps()
    end
  end
end
