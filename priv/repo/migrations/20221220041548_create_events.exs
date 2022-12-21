defmodule FurtherFrom.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :key, :string
      add :name, :string
      add :year, :integer
      add :category, :string
      add :description, :text
      add :short_name, :string

      timestamps()
    end
  end
end
