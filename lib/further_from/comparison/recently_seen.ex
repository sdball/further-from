defmodule FurtherFrom.Comparison.RecentlySeen do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recently_seen" do
    field :first_key, :string
    field :first_timeline_text, :string
    field :first_year, :integer
    field :last_key, :string
    field :last_timeline_text, :string
    field :last_year, :integer
    field :pivot_year, :integer
    field :region, :string

    timestamps()
  end

  @doc false
  def changeset(recently_seen, attrs) do
    recently_seen
    |> cast(attrs, [:region, :first_key, :last_key, :first_timeline_text, :last_timeline_text, :first_year, :last_year, :pivot_year])
    |> validate_required([:region, :first_key, :last_key, :first_timeline_text, :last_timeline_text, :first_year, :last_year, :pivot_year])
  end
end
