defmodule FurtherFrom.DataSetup do
  alias FurtherFrom.Timeline.Event
  alias FurtherFrom.Repo

  def init(_repo) do
    delete_events()
    load_events("data/events.txt") |> create_events()
  end

  def delete_events() do
    Repo.delete_all(Event)
  end

  def load_events(filepath) do
    File.read!(filepath)
    |> String.split("\n\n")
    |> Enum.map(fn event ->
      [key, summary, timeline, category, year | description] =
        String.split(event, "\n", trim: true)

      %{
        key: key,
        summary_text: summary,
        timeline_text: timeline,
        category: category,
        year: year,
        description: description |> Enum.join(" ")
      }
    end)
  end

  def create_events(events) do
    events
    |> Enum.each(fn attrs ->
      %Event{}
      |> Event.changeset(attrs)
      |> Repo.insert!()
    end)
  end
end
