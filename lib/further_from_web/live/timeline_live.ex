defmodule FurtherFromWeb.TimelineLive do
  use FurtherFromWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp get_event(key) do
    get_events()
    |> FurtherFrom.Event.lookup(key)
  end

  defp get_events do
  end
end
