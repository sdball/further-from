defmodule FurtherFrom.Timeline.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :category, :string
    field :description, :string
    field :key, :string
    field :summary_text, :string
    field :timeline_text, :string
    field :short_name, :string
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:key, :summary_text, :timeline_text, :year, :category, :description, :short_name])
    |> validate_required([:key, :summary_text, :timeline_text, :year, :category])
  end
end
