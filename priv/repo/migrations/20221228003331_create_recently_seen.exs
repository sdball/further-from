defmodule FurtherFrom.Repo.Migrations.CreateRecentlySeen do
  use Ecto.Migration

  def change do
    create table(:recently_seen) do
      add :region, :string
      add :first_key, :string
      add :last_key, :string
      add :first_timeline_text, :text
      add :last_timeline_text, :text
      add :first_year, :integer
      add :last_year, :integer
      add :pivot_year, :integer

      timestamps()
    end
  end
end
