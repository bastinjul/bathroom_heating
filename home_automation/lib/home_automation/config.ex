defmodule HomeAutomation.Config do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias HomeAutomation.Repo

  @temp_goal "TEMP_GOAL"
  @before_wake_up "MINUTES_BEFORE_WAKE_UP"
  @after_wake_up "MINUTES_AFTER_WAKE_UP"

  def temp_goal, do: @temp_goal
  def before_wake_up, do: @before_wake_up
  def after_wake_up, do: @after_wake_up

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

  def get_temp_goal() do
    query = from c in HomeAutomation.Config, where: c.label == @temp_goal, select: c.value
    Repo.one(query)
  end

  def get_minutes_before_wake_up() do
    Repo.one(from c in HomeAutomation.Config, where: c.label == @before_wake_up, select: c.value)
  end

  def get_minutes_after_wake_up() do
    Repo.one(from c in HomeAutomation.Config, where: c.label == @after_wake_up, select: c.value)
  end

  def update_temp_goal(temp) do
    {1, _} =
      from(c in HomeAutomation.Config, where: c.label == @temp_goal, select: c)
      |> Repo.update_all(set: [value: temp])
  end

  def update_minutes_before_wake_up(minutes) do
    {1, _} =
      from(c in HomeAutomation.Config, where: c.label == @before_wake_up, select: c)
      |> Repo.update_all(set: [value: minutes])
  end

  def update_minutes_after_wake_up(minutes) do
    {1, _} =
      from(c in HomeAutomation.Config, where: c.label == @after_wake_up, select: c)
      |> Repo.update_all(set: [value: minutes])
  end

end
