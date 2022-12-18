defmodule FurtherFromWeb.EventSearchLive do
  use FurtherFromWeb, :live_view

  def render(assigns) do
    ~H"""
    <p>Search for an event to start a comparison</p>
    """
  end
end
