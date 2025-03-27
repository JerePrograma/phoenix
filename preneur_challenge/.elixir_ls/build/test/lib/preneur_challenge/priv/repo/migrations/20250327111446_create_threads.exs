defmodule PreneurChallenge.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add :content, :text, null: false

      timestamps()
    end
  end
end
