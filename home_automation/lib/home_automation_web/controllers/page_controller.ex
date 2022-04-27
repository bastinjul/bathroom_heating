defmodule HomeAutomationWeb.PageController do
  use HomeAutomationWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
