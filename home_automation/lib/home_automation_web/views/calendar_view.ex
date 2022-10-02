defmodule HomeAutomationWeb.CalendarView do
  use HomeAutomationWeb, :view

  def day_class(day, current_date) do
    cond do
      today?(day) ->
        "shrink text-xs p-10 text-gray-600 border border-gray-200 bg-green-200 hover:bg-green-300 cursor-pointer"
      current_date?(day, current_date) ->
        "shrink text-xs p-10 text-gray-600 border border-gray-200 bg-blue-100 cursor-pointer"
      other_month?(day, current_date) ->
        "shrink text-xs p-10 text-gray-400 border border-gray-200 bg-gray-200 cursor-not-allowed"
      true ->
        "shrink text-xs p-10 text-gray-600 border border-gray-200 bg-white hover:bg-blue-100 cursor-pointer"
    end
  end

  defp current_date?(day, current_date) do
    Map.take(day, [:year, :month, :day]) == Map.take(current_date, [:year, :month, :day])
  end

  defp today?(day) do
    Map.take(day, [:year, :month, :day]) == Map.take(Timex.now, [:year, :month, :day])
  end

  defp other_month?(day, current_date) do
    Map.take(day, [:year, :month]) != Map.take(current_date, [:year, :month])
  end
end
