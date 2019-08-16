defmodule TodoTutorialWeb.TaskLive do
  use Phoenix.LiveView
  alias TodoTutorialWeb.TaskView
  alias TodoTutorial.Todo
  alias TodoTutorial.Todo.Task

  def render(assigns), do: TaskView.render("index.html", assigns)

  def mount(_session, socket) do
    {:ok,
     assign(socket,
       tasks: Todo.list_tasks(),
       changeset: Todo.change_task(%Task{})
     )}
  end

  def handle_event("add_task", %{"task" => task_params}, socket) do
    case Todo.create_task(task_params) do
      {:ok, _} ->
        {:noreply,
         assign(socket,
           tasks: Todo.list_tasks() |> IO.inspect(),
           changeset: Todo.change_task(%Task{})
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("toggle_is_finished", id, socket) do
    task = Todo.get_task!(id)
    Todo.update_task(task, %{is_finished: !task.is_finished})
    {:noreply, assign(socket, tasks: Todo.list_tasks())}
  end
end
