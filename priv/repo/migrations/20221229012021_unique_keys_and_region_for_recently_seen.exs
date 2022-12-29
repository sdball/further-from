defmodule FurtherFrom.Repo.Migrations.UniqueKeysAndRegionForRecentlySeen do
  use Ecto.Migration

  def change do
    FurtherFrom.Repo.delete_all(FurtherFrom.Comparison.RecentlySeen)
    create unique_index(:recently_seen, [:first_key, :last_key, :region])
  end
end
