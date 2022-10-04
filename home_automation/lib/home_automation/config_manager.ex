defmodule HomeAutomation.ConfigManager do
  alias HomeAutomation.Repo
  alias HomeAutomation.Config

  def update_temp_goal(temp) do
    Config.update_temp_goal(temp)
  end

  def update_minutes_before_wake_up(minutes) do
    Config.update_minutes_before_wake_up(minutes)
  end

  def update_minutes_after_wake_up(minutes) do
    Config.update_minutes_after_wake_up(minutes)
  end

  def get_temp_goal() do
    Config.get_temp_goal()
  end

  def get_minutes_before_wake_up() do
    Config.get_minutes_before_wake_up()
  end

  def get_minutes_after_wake_up() do
    Config.get_minutes_after_wake_up()
  end

  def insert_config(attrs \\ %{}) do
    %Config{}
    |> Config.changeset(attrs)
    |> Repo.insert()
  end
  
end
