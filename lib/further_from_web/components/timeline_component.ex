defmodule FurtherFromWeb.TimelineComponent do
  use Phoenix.Component

  def event(assigns) do
    ~H"""
    <div class="flex-start flex items-center pt-2">
      <div class="-ml-1 mr-3 h-2 w-2 rounded-full bg-gray-300"></div>
      <p class="text-2xl text-gray-800"><%= @event.year %></p>
    </div>
    <div class="mt-0.5 ml-4 mb-6">
      <h4 class="mb-1.5 text-xl font-semibold text-gray-800">The <%= @event.name %></h4>
      <p class="text-l mb-1.5 font-light text-gray-800"><%= @event.description %></p>
    </div>
    """
  end
end
