defmodule FurtherFromWeb.EventLive do
  use FurtherFromWeb, :live_view
  alias FurtherFromWeb.TimelineComponent
  alias FurtherFrom.Timeline

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"event" => event_key}, _url, socket) do
    current_year = Date.utc_today().year
    event = Timeline.get_event_by_key_or_year(event_key)

    {:noreply,
     assign(socket,
       event: event,
       matched_events: [],
       current_year: current_year,
       page_title: "#{event.timeline_text} (#{event.year})"
     )}
  end

  def handle_event("select-event", %{"item" => event2_key}, socket) do
    event1_key = socket.assigns.event.key
    {:noreply, push_navigate(socket, to: ~p"/compare/#{event1_key}/#{event2_key}")}
  end

  def handle_event("remove", _params, socket) do
    {:noreply, push_navigate(socket, to: ~p"/compare")}
  end
end
