defmodule FurtherFromWeb.HomeLive do
  use FurtherFromWeb, :live_view

  @page_title "Home"

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
        |> assign(:page_title, @page_title)
      end

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket |> assign(:page_title, @page_title)}
  end

  defp get_random_event() do
    FurtherFrom.Timeline.get_random_event()
  end

  defp get_random_event(omit: omit_event) do
    FurtherFrom.Timeline.get_random_event(omit: omit_event)
  end
end
