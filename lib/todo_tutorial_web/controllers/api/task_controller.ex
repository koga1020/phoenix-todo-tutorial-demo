defmodule TodoTutorialWeb.Api.TaskController do
  use TodoTutorialWeb, :controller
  use PhoenixSwagger

  alias TodoTutorial.Todo
  alias TodoTutorial.Todo.Task

  action_fallback TodoTutorialWeb.FallbackController

  def swagger_definitions do
    %{
      Task:
        swagger_schema do
          title("Task")

          properties do
            id(:integer, "Task ID")
            name(:string, "Task name", required: true)
            is_finished(:boolean, "Task is finished")
            finished_at(:string, "timestamp when task completed", format: :datetime)
          end

          example(%{
            id: 123,
            name: "sample task",
            is_finished: false,
            finished_at: nil
          })
        end,
      TaskRequest:
        swagger_schema do
          title("TaskRequest")
          property(:task, Schema.ref(:Task), "The task details")
        end,
      TaskResponse:
        swagger_schema do
          title("TaskResponse")
          property(:data, Schema.ref(:Task), "The task details")
        end,
      TasksResponse:
        swagger_schema do
          title("TasksReponse")
          property(:data, Schema.array(:Task), "The tasks details")
        end
    }
  end

  swagger_path :index do
    get("/api/tasks")
    summary("List Tasks")
    parameter(:include_finished, :query, :string, "when true, include finished task")

    response(200, "OK", Schema.ref(:TasksResponse))
  end

  def index(conn, params) do
    options = [
      include_finished: Map.get(params, "include_finished") == "true"
    ]

    tasks = Todo.list_tasks(options)
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Todo.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Todo.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Todo.get_task!(id)

    with {:ok, %Task{} = task} <- Todo.update_task(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Todo.get_task!(id)

    with {:ok, %Task{}} <- Todo.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
