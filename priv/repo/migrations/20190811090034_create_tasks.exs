defmodule TodoTutorial.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :is_finished, :boolean, default: false, null: false
      add :finished_at, :naive_datetime

      timestamps()
    end
  end
end
