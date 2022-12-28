defmodule FurtherFrom.Engine do
  require Logger

  alias FurtherFrom.Comparison

  def compare(primary, secondary) do
    [first, last] =
      Enum.sort([primary, secondary], fn x, y ->
        x.year <= y.year
      end)

    difference = abs(first.year - last.year)
    pivot_year = last.year + difference

    %Comparison{pivot_year: pivot_year, first: first, last: last, difference: difference}
    |> write_to_recently_seen()
  end

  def write_to_recently_seen(comparison) do
    %{
      first_key: comparison.first.key,
      first_timeline_text: comparison.first.timeline_text,
      first_year: comparison.first.year,
      last_key: comparison.last.key,
      last_timeline_text: comparison.last.timeline_text,
      last_year: comparison.last.year,
      pivot_year: comparison.pivot_year,
      region: System.get_env("FLY_REGION") || "local"
    }
    |> Comparison.create_recently_seen()
    |> case do
      {:ok, recently_seen} ->
        Logger.info(recently_seen)
        FurtherFromWeb.Endpoint.broadcast!("recently_seen_comparison", "created", recently_seen)

      {:error, error} ->
        Logger.error(error)
    end

    comparison
  end

  def comparisons(collection, event) do
    collection
    |> Enum.filter(fn comp ->
      comp.key != event.key
    end)
    |> Enum.map(fn comp ->
      compare(event, comp)
    end)
    |> Enum.sort(fn a, b ->
      a.pivot_year < b.pivot_year
    end)
  end
end
