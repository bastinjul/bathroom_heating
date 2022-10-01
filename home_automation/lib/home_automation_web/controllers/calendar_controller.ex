defmodule HomeAutomationWeb.CalendarController do
  use HomeAutomationWeb, :live_view
  use Timex
  require Logger

  alias HomeAutomation.HeatingManager

  @week_start_at :mon

  def mount(_params, _session, socket) do
    current_date = Timex.now()
    week_rows = week_rows(current_date)
    wake_up_map = HeatingManager.wake_up_days_of_month(List.flatten(week_rows))
    IO.inspect wake_up_map
    IO.inspect week_rows
    assigns = [
      conn: socket,
      current_date: current_date,
      day_names: day_names(@week_start_at),
      week_rows: week_rows,
      wake_up_map: wake_up_map
    ]

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    Phoenix.View.render(HomeAutomationWeb.CalendarView, "index.html", assigns)
  end

  def handle_event("prev-month", _, socket) do
    change_month(socket, -1)
  end

  def handle_event("next-month", _, socket) do
    change_month(socket, 1)
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    current_date = Timex.parse!(date, "{YYYY}-{0M}-{D}")
    Logger.debug IEx.Info.info(current_date)
    assigns = [
      current_date: current_date
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp change_month(socket, month) do
    current_date = Timex.shift(socket.assigns.current_date, months: month)
    week_rows = week_rows(current_date)
    wake_up_map = HeatingManager.wake_up_days_of_month(List.flatten(week_rows))
    assigns = [
      current_date: current_date,
      week_rows: week_rows,
      wake_up_map: wake_up_map
    ]

    {:noreply, assign(socket, assigns)}
  end

  defp day_names(:sun), do: [7, 1, 2, 3, 4, 5, 6] |> Enum.map(&Timex.day_shortname/1)
  defp day_names(_), do: [1, 2, 3, 4, 5, 6, 7] |> Enum.map(&Timex.day_shortname/1)

  defp week_rows(current_date) do
    first =
      current_date
      |> Timex.beginning_of_month()
      |> Timex.beginning_of_week(@week_start_at)

    last =
      current_date
      |> Timex.end_of_month()
      |> Timex.end_of_week(@week_start_at)

    Interval.new(from: first, until: last)
    |> Enum.map(& &1)
    |> Enum.chunk_every(7)
  end
end
