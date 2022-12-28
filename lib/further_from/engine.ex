defmodule FurtherFrom.Engine do
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
    FurtherFrom.Comparison.RecentlySeen
    |> Ash.Changeset.for_create(:create, %{
      last_timeline_text: comparison.last.timeline_text,
      first_timeline_text: comparison.first.timeline_text,
      first_key: comparison.first.key,
      last_key: comparison.last.key,
      first_year: comparison.first.year,
      last_year: comparison.last.year,
      pivot_year: comparison.pivot_year,
    })
    |> FurtherFrom.Comparison.create!()
    |> then(fn recently_seen ->
      FurtherFromWeb.Endpoint.broadcast!("recently_seen_comparison", "created", recently_seen)
    end)

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
