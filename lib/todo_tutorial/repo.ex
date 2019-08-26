defmodule TodoTutorial.Repo do
  use Ecto.Repo,
    otp_app: :todo_tutorial,
    adapter: Ecto.Adapters.Postgres
end
