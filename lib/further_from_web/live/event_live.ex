defmodule FurtherFromWeb.EventLive do
  use FurtherFromWeb, :live_view
  alias FurtherFromWeb.TimelineComponent
  alias FurtherFrom.Event

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"event" => event_key}, _url, socket) do
    current_year = Date.utc_today().year
    event = get_event_or_year(event_key)
    {:noreply, assign(socket, event: event, matched_events: [], current_year: current_year)}
  end

  def handle_event("search", %{"value" => value}, socket) do
    matched_events =
      FurtherFrom.Event.get_events()
      |> Enum.reject(fn event ->
        event.key == socket.assigns.event.key
      end)
      |> Enum.filter(fn event ->
        String.downcase(event.name) =~ String.downcase(value)
        || event.year |> Integer.to_string() =~ value 
      end)

    {:noreply, assign(socket, :matched_events, matched_events)}
  end

  def handle_event("select-event", %{"item" => event2_key}, socket) do
    event1_key = socket.assigns.event.key
    {:noreply, push_navigate(socket, to: ~p"/compare/#{event1_key}/#{event2_key}")}
  end

  def handle_event("remove", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/compare")}
  end

  defp get_event_or_year(key) do
    event =
      FurtherFrom.Event.get_events()
      |> FurtherFrom.Event.lookup(key)

    cond do
      is_nil(event) && Regex.match?(~r/\d\d\d\d/, key) ->
        Event.build_year_event(key |> String.to_integer())

      true ->
        event
    end
  end
end
