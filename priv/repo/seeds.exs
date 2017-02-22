# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DoubleRed.Repo.insert!(%DoubleRed.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DoubleRed.Repo
alias DoubleRed.Location

Repo.delete_all Location
Repo.insert! %Location{ name: "Left", zone: 0 }
Repo.insert! %Location{ name: "Right", zone: 1 }
