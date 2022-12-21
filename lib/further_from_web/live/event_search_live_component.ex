defmodule FurtherFromWeb.EventSearchLiveComponent do
  use Phoenix.LiveComponent

  def mount(socket) do
    socket =
      socket
      |> assign(:matched_events, [])
      |> assign(:events_count, 0)

    {:ok, socket}
  end

  def handle_event("search", %{"value" => value}, socket) do
    matched_events =
      FurtherFrom.Timeline.list_events()
      |> Enum.filter(fn event ->
        String.downcase(event.name) =~ String.downcase(value) ||
          event.year |> Integer.to_string() =~ value ||
          event.category =~ value
      end)

    matched_events =
      if Map.has_key?(socket.assigns, :selected_event) do
        matched_events
        |> Enum.reject(fn event ->
          event.key == socket.assigns.selected_event.key
        end)
      else
        matched_events
      end

    {:noreply, assign(socket, :matched_events, matched_events)}
  end

  def render(assigns) do
    ~H"""
    <div class="py-8 px-16" id="{id}">
      <label class="text-lg text-grey-500 font-bold pb-2"><%= @title %>:</label>
      <input
        class="border border-solid border-grey-700 rounded p-2 min-w-full"
        id="search-input"
        autocomplete="off"
        type="text"
        phx-keyup="search"
        phx-target={@myself}
      />

      <div class="bg-white mt-2 rounded shadow">
        <div class="p-4 pb-2 italic text-sm text-gray-400">
          <%= @events_count %> <%= Inflex.inflect("Results", @events_count) %>
        </div>
        <%= for event <- @matched_events do %>
          <div
            class="px-4 py-2 cursor-pointer hover:bg-gray-100 first:pt-4 last:pb-4"
            phx-click="select-event"
            phx-value-item={event.key}
          >
            <%= event.year %> — the <%= event.name %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
