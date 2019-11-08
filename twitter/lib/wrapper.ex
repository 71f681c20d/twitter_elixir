defmodule Wrapper do # wraps a centralized ETS instance
  use GenServer

  def init(arg) do
    :ets.new(:wrapper, [
      :set,
      :public,
      :named_table,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ])

    {:ok, arg}
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def get(key) do
    case :ets.lookup(:wrapper, key) do
      [] ->
        nil
      [{_key, value}] ->
        value
    end
  end

  def get(key, value) do
    GenServer.cast(from_pid, {:get, key, value})   
  end

  def handle_cast({:get, key, value}, state) do
    :ets.insert(:wrapper, {key, value})
  end
  
  def put(key, value) do
    GenServer.call(from_pid, {:put, key, value})
    -> :ok  
  end

  def handle_call({:put, key, value}, state) do
    :ets.insert(:wrapper, {key, value})
    -> :ok
  end
end
