defmodule FurtherFromWeb.ComparisonLive do
  use FurtherFromWeb, :live_view
  alias FurtherFromWeb.TimelineComponent
  alias FurtherFrom.Timeline

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"event1" => event1_key, "event2" => event2_key}, _url, socket) do
    current_year = Date.utc_today().year
    event1 = get_event_or_year(event1_key)
    event2 = get_event_or_year(event2_key)
    comparison = FurtherFrom.Engine.compare(event1, event2)

    socket = assign(socket, comparison: comparison, current_year: current_year)

    {:noreply,
     assign(socket,
       page_title:
       "#{comparison.first.timeline_text} (#{comparison.first.year}) / #{comparison.last.timeline_text} (#{comparison.last.year})",
       page_description: TimelineComponent.comparison_summary_text(socket.assigns)
     )}
  end

  def handle_event("remove", %{"event-key" => remove_key}, socket) do
    remaining_event =
      [socket.assigns.comparison.first, socket.assigns.comparison.last]
      |> Enum.find(fn event ->
        event.key != remove_key
      end)

    {:noreply, push_navigate(socket, to: ~p"/compare/#{remaining_event.key}")}
  end

  defp get_event_or_year(key) do
    event = Timeline.get_event_by_key(key)

    cond do
      is_nil(event) && Regex.match?(~r/\d\d\d\d/, key) ->
        Timeline.build_year_event(key |> String.to_integer())

      true ->
        event
    end
  end
end
