defmodule FurtherFromWeb.InterestingPairsLive do
  use FurtherFromWeb, :live_view
  alias FurtherFrom.Event

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_new(:interesting_pairs, fn ->
        interesting_pairs()
      end)

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp interesting_pairs() do
    events = Event.get_events()

    [
      {"first-flight", "apollo-11-moon-landing"},
      {"forrest-gump-in-vietnam-war", "forrest-gump-movie-release"},
      {"nes", "snes"},
      {"earliest-videogame", "nes"}
    ]
    |> Enum.map(fn {key1, key2} ->
      {
        Event.lookup(events, key1),
        Event.lookup(events, key2)
      }
    end)
  end
end
