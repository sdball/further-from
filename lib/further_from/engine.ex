defmodule FurtherFrom.Engine do
  alias FurtherFrom.Comparison

  def compare(primary, secondary) do
    [first, last] =
      Enum.sort([primary, secondary], fn x, y ->
        x.year <= y.year
      end)

    difference = abs(first.year - last.year)
    pivot_year = last.year + difference
    first = maybe_shortname(first)
    last = maybe_shortname(last)
    %Comparison{pivot_year: pivot_year, first: first, last: last, difference: difference}
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

  defp maybe_shortname(event) do
    if is_nil(event.short_name) do
      Map.put(event, :short_name, event.name)
    else
      event
    end
  end
end
