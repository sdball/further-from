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
    {:noreply, assign(socket, event: event, current_year: current_year)}
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
