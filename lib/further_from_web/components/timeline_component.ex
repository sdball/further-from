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

  def comparison_summary(assigns) do
    cond do
      assigns.comparison.pivot_year < assigns.current_year ->
        past_comparison(assigns)

      true ->
        future_comparison(assigns)
    end
  end

  def past_comparison(assigns) do
    ~H"""
    <div class="flex-start flex items-center pt-3">
      <div class="-ml-1 mr-3 h-2 w-2 rounded-full bg-gray-300"></div>
      <p class="text-2xl text-gray-800"><%= @comparison.pivot_year %></p>
    </div>
    <div class="mt-0.5 ml-4 mb-6">
      <h4 class="mb-1.5 text-xl font-semibold text-gray-800">
        We got further from the <%= @comparison.last.short_name %> than the <%= @comparison.last.short_name %> was from the <%= @comparison.first.short_name %>.
      </h4>
    </div>
    """
  end

  def future_comparison(assigns) do
    ~H"""
    <div class="flex-start flex items-center pt-3">
      <div class="-ml-1 mr-3 h-2 w-2 rounded-full bg-gray-300"></div>
      <p class="text-2xl text-gray-800"><%= @comparison.pivot_year %></p>
    </div>
    <div class="mt-0.5 ml-4 mb-6">
      <h4 class="mb-1.5 text-xl font-semibold text-gray-800">
        In <%= @comparison.pivot_year %> we'll be further from the <%= @comparison.last.short_name %> than the <%= @comparison.last.short_name %> was from the <%= @comparison.first.short_name %>. These events were <%= @comparison.difference %> years apart.
      </h4>
    </div>
    """
  end
end
