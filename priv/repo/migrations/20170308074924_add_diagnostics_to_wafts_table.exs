defmodule DoubleRed.Repo.Migrations.AddDiagnosticsToWaftsTable do
  use Ecto.Migration

  def change do
    alter table(:wafts) do
      add :battery_percentage, :integer
      add :battery_adc_level, :integer
      add :wifi_rssi, :integer
    end
  end
end
