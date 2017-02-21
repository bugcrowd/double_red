defmodule DoubleRed.Repo.Migrations.CreateWaft do
  use Ecto.Migration

  def change do
    create table(:wafts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :temperature, :integer, null: false
      add :lumens, :integer, null: false
      add :red, :integer, null: false
      add :green, :integer, null: false
      add :blue, :integer, null: false

      timestamps()
    end

    create constraint("wafts", "positive_temperature", check: "temperature >= 0")
    create constraint("wafts", "valid_temperature", check: "temperature <= 65535")
    create constraint("wafts", "positive_lumens", check: "lumens >= 0")
    create constraint("wafts", "valid_lumens", check: "lumens <= 65535")
    create constraint("wafts", "positive_red", check: "red > 0")
    create constraint("wafts", "valid_red", check: "red <= 65535")
    create constraint("wafts", "positive_green", check: "green > 0")
    create constraint("wafts", "valid_green", check: "green <= 65535")
    create constraint("wafts", "positive_blue", check: "blue > 0")
    create constraint("wafts", "valid_blue", check: "blue <= 65535")
  end
end
