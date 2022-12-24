defmodule FurtherFromWeb.TimelineComponent do
  use Phoenix.Component

  def event(assigns) do
    ~H"""
    <div class="flex-start flex items-center pt-2">
      <.timeline_dot event={@event} />
      <p class="text-2xl text-gray-800 ml-3"><%= @event.year %></p>
    </div>
    <div class="mt-0.5 ml-4 mb-6">
      <h4 class="mb-1.5 text-xl font-semibold text-gray-800"><%= @event.timeline_text %></h4>
      <p class="text-l mb-1.5 font-light text-gray-800"><%= @event.description %></p>
    </div>
    """
  end

  def timeline_dot(assigns) when not is_map_key(assigns, :event) do
    ~H"""
    <div class="bg-gray-300 w-6 h-6 flex items-center justify-center rounded-full -ml-3">
      <Heroicons.calendar class="w-3 h-3" />
    </div>
    """
  end

  def timeline_dot(assigns) do
    ~H"""
    <div
      class="group bg-gray-300 w-6 h-6 flex items-center justify-center rounded-full -ml-3 hover:bg-red-300"
      phx-click="remove"
      phx-value-event-key={@event.key}
    >
      <Heroicons.calendar class="w-3 h-3 group-hover:hidden" />
      <Heroicons.x_mark class="w-3 h-3 hidden group-hover:flex" />
    </div>
    """
  end

  def comparison_summary(assigns) do
    ~H"""
    <div class="flex-start flex items-center pt-3">
      <.timeline_dot />
      <p class="text-2xl text-gray-800 ml-3"><%= @comparison.pivot_year %></p>
    </div>
    <div class="mt-0.5 ml-4 mb-6">
      <h4 class="mb-1.5 text-xl font-semibold text-gray-800">
        <.comparison_summary_text comparison={@comparison} current_year={@current_year} />
      </h4>
    </div>
    """
  end

  def comparison_summary_text(assigns) do
    cond do
      assigns.comparison.first.year == assigns.comparison.last.year ->
        same_year_comparison(assigns)

      assigns.comparison.pivot_year < assigns.current_year ->
        past_comparison(assigns)

      true ->
        future_comparison(assigns)
    end
  end

  def same_year_comparison(assigns) do
    ~H"""
    The <%= @comparison.last.summary_text %> and the <%= @comparison.first.summary_text %> both happened in <%= @comparison.first.year %>.
    """
  end

  def past_comparison(assigns) do
    ~H"""
    In <%= @comparison.pivot_year %> we got further from the <%= @comparison.last.summary_text %> than the <%= @comparison.last.summary_text %> was from the <%= @comparison.first.summary_text %>. These events were <%= @comparison.difference %> years apart.
    """
  end

  def future_comparison(assigns) do
    ~H"""
    In <%= @comparison.pivot_year %> we'll be further from the <%= @comparison.last.summary_text %> than the <%= @comparison.last.summary_text %> was from the <%= @comparison.first.summary_text %>. These events were <%= @comparison.difference %> years apart.
    """
  end
end
