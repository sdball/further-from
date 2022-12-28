defmodule FurtherFrom.Subscriber do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(state = %{topics: topics}) do
    topics
    |> Enum.each(fn topic ->
      FurtherFromWeb.Endpoint.subscribe(topic)
      # FurtherFromWeb.Endpoint.subscribe("recently_seen_comparison")
    end)

    state = Map.put(state, :region, System.get_env("FLY_REGION") || "local")

    {:ok, state}
  end

  @impl true
  def handle_info(%{topic: "recently_seen_comparison", event: "created", payload: recently_seen}, state) do
    if recently_seen.region != state.region do
      recently_seen
      |> Map.from_struct()
      |> FurtherFrom.Comparison.create_recently_seen()
    else
      dbg("got a comparison from our region")
    end

    {:noreply, state}
  end
end
