defmodule TodoTutorial.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :finished_at, :naive_datetime
    field :is_finished, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :is_finished, :finished_at])
    |> validate_required([:name, :is_finished, :finished_at])
  end
end
