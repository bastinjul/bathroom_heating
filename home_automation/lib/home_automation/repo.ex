defmodule HomeAutomation.Repo do
  use Ecto.Repo,
    otp_app: :home_automation,
    adapter: Ecto.Adapters.Postgres
end
