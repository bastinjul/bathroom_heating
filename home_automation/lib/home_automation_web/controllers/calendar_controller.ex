defmodule HomeAutomationWeb.CalendarLive do
  use HomeAutomationWeb, :live_view
  use Timex
  require Logger

  alias HomeAutomation.HeatingManager
  alias HomeAutomation.CalendarManager

  @week_start_at :mon

  def mount(_params, _session, socket) do
    current_date = Timex.now()
    week_rows = week_rows(current_date)
    wake_up_map = HeatingManager.wake_up_days_of_month(List.flatten(week_rows))
    assigns = [
      conn: socket,
      current_date: current_date,
      day_names: day_names(@week_start_at),
      week_rows: week_rows,
      wake_up_map: wake_up_map,
      modifying: false
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
    assigns = [
      current_date: current_date
    ]

    {:noreply, push_patch(assign(socket, assigns), to: "/calendar/modal")}
  end

  def handle_event("modify-wake-up-time", _, socket) do

    {:noreply, assign(socket, modifying: true)}
  end

  def handle_event("delete-wake-up-time", _, socket) do
    current_date_d = NaiveDateTime.to_date(socket.assigns.current_date)
    CalendarManager.delete_wake_up_time(current_date_d)
    new_wake_up_map = Map.delete(socket.assigns.wake_up_map, current_date_d)
    {:noreply, push_patch(assign(socket, wake_up_map: new_wake_up_map), to: "/calendar")}
  end

  def handle_event("save", %{"time" => %{"time_pick" => new_time_str}}, socket) do
    {:ok, new_time} = Time.from_iso8601("#{new_time_str}:00")
    current_date_d = NaiveDateTime.to_date(socket.assigns.current_date)
    if Map.has_key?(socket.assigns.wake_up_map, current_date_d) do
      CalendarManager.modify_calendar(current_date_d, new_time)
    else
      CalendarManager.insert_calendar(%{wake_up_time: new_time, day: socket.assigns.current_date})
    end
    new_wake_up_map = Map.put(socket.assigns.wake_up_map, current_date_d, new_time)
    {:noreply, push_patch(assign(socket, wake_up_map: new_wake_up_map), to: "/calendar")}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, socket}
  end

  # The modal component emits this event when `PetalComponents.Modal.hide_modal()` is called.
  # This happens when the user clicks the dark background or the 'X'.
  @impl true
  def handle_event("close_modal", _, socket) do

    # Go back to the :index live action
    {:noreply, push_patch(socket, to: "/calendar")}
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
