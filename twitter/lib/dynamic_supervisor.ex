defmodule MyDynamicSupervisor do
  use DynamicSupervisor

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(
      strategy: :one_for_one
    )
  end

  def start_child(id_num) do
    spec = %{id: id_num, start: {Client, :start_link, []}}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def start_engine do
    Engine.start_link()
  end

  def start_clients(num_clients) do start_clients(num_clients, []) end
  def start_clients(0, list) do list end
  def start_clients(num_clients, list) do
    {:ok, pid} = start_child(Integer.to_string(num_clients))
    user = %{uid: Integer.to_string(num_clients), pid: pid}
    start_clients(num_clients - 1, [user | list])
  end

end
