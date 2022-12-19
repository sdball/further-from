defmodule FurtherFromWeb.HomeLive do
  use FurtherFromWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      if connected?(socket) do
        socket
        |> assign_new(:comparison, fn ->
          event1 = get_random_event()
          event2 = get_random_event(omit: event1)
          FurtherFrom.Engine.compare(event1, event2)
        end)
        |> assign_new(:current_year, fn ->
          Date.utc_today().year
        end)
      else
        socket
        |> assign(:comparison, nil)
        |> assign(:current_year, nil)
      end

    {:ok, socket}
  end

  # def handle_params(_params, _url, socket) do
  #   current_year = Date.utc_today().year
  #   event1 = get_random_event()
  #   event2 = get_random_event(omit: event1)
  #   comparison = FurtherFrom.Engine.compare(event1, event2)
  #   {:noreply, assign(socket, comparison: comparison, current_year: current_year)}
  # end

  defp get_random_event() do
    FurtherFrom.Event.random_event()
  end

  defp get_random_event(omit: omit_event) do
    FurtherFrom.Event.random_event(omit: omit_event)
  end
end
