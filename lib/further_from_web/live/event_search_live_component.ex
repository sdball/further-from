defmodule FurtherFromWeb.EventSearchLiveComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <h2 class="text-2xl font-bold"><%= @title %></h2>
    """
  end
end
