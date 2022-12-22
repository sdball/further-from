defmodule FurtherFromWeb.EventSearchLive do
  use FurtherFromWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:page_title, "Search for an event")}
  end

  def handle_event("select-event", %{"item" => event_key}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/compare/#{event_key}")}
  end
end
