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

Repo.insert!(%HomeAutomation.Config{label: "TEMP_GOAL", value: "20"})
Repo.insert!(%HomeAutomation.Config{label: "MINUTES_BEFORE_WAKE_UP", value: "90"})
