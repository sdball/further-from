defmodule FurtherFromWeb.ComparisonLive do
  use FurtherFromWeb, :live_view
  alias FurtherFromWeb.TimelineComponent
  require Logger

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"event1" => event1_key, "event2" => event2_key}, _url, socket) do
    current_year = Date.utc_today().year
    event1 = get_event(event1_key)
    event2 = get_event(event2_key)
    comparison = FurtherFrom.Engine.compare(event1, event2)
    {:noreply, assign(socket, comparison: comparison, current_year: current_year)}
  end

  defp get_event(key) do
    FurtherFrom.Event.get_events()
    |> FurtherFrom.Event.lookup(key)
  end
end
