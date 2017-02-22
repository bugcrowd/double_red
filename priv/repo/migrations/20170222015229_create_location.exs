defmodule DoubleRed.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :zone, :integer

      timestamps()
    end
  end
end
