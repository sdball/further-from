defmodule FurtherFromWeb.TimelineLive do
  use FurtherFromWeb, :live_view
  require Logger

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_params, _session, socket) do
    {:noreply, socket}
  end
end
