defmodule FurtherFrom.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FurtherFrom.Timeline` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        category: "movie",
        description: "A complete sentence or sentences succiently describing the event in question.",
        key: "essentially-a-url-slug",
        name: "event (should read well with a leading 'the')",
        short_name: "short, colloquial name e.g. NES for Nintendo Entertainment System",
        year: 1999
      })
      |> FurtherFrom.Timeline.create_event()

    event
  end
end
