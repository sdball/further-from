defmodule FurtherFromWeb.EventSearchLive do
  use FurtherFromWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    current_year = Date.utc_today().year
    {:noreply, assign(socket, matched_events: [], current_year: current_year)}
  end

  def handle_event("search", %{"value" => value}, socket) do
    matched_events =
      FurtherFrom.Timeline.list_events()
      |> Enum.filter(fn event ->
        String.downcase(event.name) =~ String.downcase(value)
      end)

    {:noreply, assign(socket, :matched_events, matched_events)}
  end

  def handle_event("select-event", %{"item" => event_key}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/compare/#{event_key}")}
  end
end
