defmodule FurtherFrom.ComparisonFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FurtherFrom.Comparison` context.
  """

  @doc """
  Generate a recently_seen.
  """
  def recently_seen_fixture(attrs \\ %{}) do
    {:ok, recently_seen} =
      attrs
      |> Enum.into(%{
        first_key: "some first_key",
        first_timeline_text: "some first_timeline_text",
        first_year: 42,
        last_key: "some last_key",
        last_timeline_text: "some last_timeline_text",
        last_year: 42,
        pivot_year: 42,
        region: "some region"
      })
      |> FurtherFrom.Comparison.create_recently_seen()

    recently_seen
  end
end
