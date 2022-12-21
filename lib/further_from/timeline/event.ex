defmodule FurtherFrom.Timeline.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :category, :string
    field :description, :string
    field :key, :string
    field :name, :string
    field :short_name, :string
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:key, :name, :year, :category, :description, :short_name])
    |> validate_required([:key, :name, :year, :category])
  end
end
