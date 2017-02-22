defmodule DoubleRed.Repo.Migrations.AddLocationIdToWaftsTable do
  use Ecto.Migration

  def change do
    alter table(:wafts) do
      add :location_id, references(:locations, type: :uuid)
    end
    create index(:wafts, [:location_id])
  end
end
