defmodule FurtherFrom.Repo.Migrations.AddTimelineTextToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :timeline_text, :string
    end
  end
end
