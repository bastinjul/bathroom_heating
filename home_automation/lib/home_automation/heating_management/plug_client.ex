defmodule HomeAutomation.HeatingManager.PlugClient do
  require Logger
  use Tesla

  plug Tesla.Middleware.BaseUrl, System.get_env("PLUG_URL")
  plug Tesla.Middleware.JSON

  @doc """
  Get the plug status.
  """
  @spec get_plug_status :: bool
  def get_plug_status() do
    send_request("/is_on")
  end

  @doc """
  Trun on the plug
  """
  @spec turn_on_plug :: bool
  def turn_on_plug() do
    send_request("/turn_on")
  end

  @doc """
  Turn off the plug
  """
  @spec turn_off_plug :: bool
  def turn_off_plug() do
    send_request("/turn_off")
  end

  defp send_request(path) do
    Logger.debug "Sending request to plug: #{path}"
    {:ok, response} = get(path)
    %{"is_on" => status} = response.body
    Logger.debug "Got plug status: #{status}"
    status
  end

end
