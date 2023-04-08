defmodule FurtherFrom.Subscriber do
  @moduledoc """
  Allow subscribing to topics as declared in `application.ex` and handle topic
  messages. Currently only supports `recently_seen_comparisons` to persist
  recently seen comparisons from outside the current region.
  """

  require Logger

  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(%{topics: topics} = state) do
    topics
    |> Enum.each(fn topic ->
      FurtherFromWeb.Endpoint.subscribe(topic)
    end)

    state = Map.put(state, :region, System.get_env("FLY_REGION") || "local")

    {:ok, state}
  end

  @impl true
  def handle_info(
        %{topic: "recently_seen_comparison", event: "created", payload: recently_seen},
        state
      ) do
    if recently_seen.region != state.region do
      recently_seen
      |> Map.from_struct()
      |> FurtherFrom.Comparison.create_recently_seen()
    else
      Logger.debug("got a comparison from our region")
    end

    {:noreply, state}
  end
end
