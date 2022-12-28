defmodule FurtherFromWeb.HomeLive do
  use FurtherFromWeb, :live_view

  @page_title "Home"

  def mount(_params, _session, socket) do
    FurtherFromWeb.Endpoint.subscribe("recently_seen_comparison")

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
        |> recent_comparisons()
      else
        socket
        |> assign(:comparison, nil)
        |> assign(:current_year, nil)
        |> assign(:recent_comparisons, nil)
        |> assign(:page_title, @page_title)
      end

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket |> assign(:page_title, @page_title)}
  end

  def handle_info(
        %Phoenix.Socket.Broadcast{
          topic: "recently_seen_comparison",
          event: "created",
          payload: recently_seen
        },
        socket
      ) do
    if socket.assigns.recent_comparisons do
      new_recent_comparisons = [recently_seen] ++ socket.assigns.recent_comparisons

      {:noreply, socket |> assign(:recent_comparisons, new_recent_comparisons |> Enum.take(10))}
    else
      {:noreply, socket |> recent_comparisons()}
    end
  end

  defp get_random_event() do
    FurtherFrom.Timeline.get_random_event()
  end

  defp get_random_event(omit: omit_event) do
    FurtherFrom.Timeline.get_random_event(omit: omit_event)
  end

  defp recent_comparisons(socket) do
    socket
    |> assign(:recent_comparisons, recently_seen_comparisons())
  end

  defp recently_seen_comparisons(limit \\ 10) do
    FurtherFrom.Comparison.recently_seen(limit)
  end
end
