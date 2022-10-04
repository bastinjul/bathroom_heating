# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HomeAutomation.Repo.insert!(%HomeAutomation.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias HomeAutomation.Repo
alias HomeAutomation.Config

Repo.insert!(%Config{label: Config.temp_goal(), value: "20"})
Repo.insert!(%Config{label: Config.before_wake_up(), value: "90"})
Repo.insert!(%Config{label: Config.after_wake_up(), value: "30"})