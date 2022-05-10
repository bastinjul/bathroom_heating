defmodule HomeAutomationWeb.PlugController do
  use HomeAutomationWeb, :controller

  alias HomeAutomation.HeatingManager

  def index(conn, _params) do
    plug_status = HeatingManager.get_plug_status()
    render(conn, "index.html", plug_status: plug_status)
  end

  def switch(conn, _params) do
    plug_status = HeatingManager.switch_plug()
    render(conn, "index.html", plug_status: plug_status)
  end

end
