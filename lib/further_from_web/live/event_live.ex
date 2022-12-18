defmodule FurtherFromWeb.EventLive do
  use FurtherFromWeb, :live_view

  def render(assigns) do
    ~H"""
    <p>Search for a second event to create a comparison</p>
    """
  end
end
