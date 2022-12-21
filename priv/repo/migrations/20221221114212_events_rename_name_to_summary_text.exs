defmodule FurtherFrom.Repo.Migrations.RenameNameToSummaryText do
  use Ecto.Migration

  def change do
    rename table(:events), :name, to: :summary_text
  end
end
