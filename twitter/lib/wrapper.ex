defmodule Wrapper do # wraps a centralized ETS instance
  use GenServer

  def init(arg) do
    :mnesia.create_schema([node()])
    :mnesia.start
    
    {:ok,_} = :mnesia.create_table(hashtags, [attributes: [:hashtag, :tweets]]) # [#i_luv_twitter, {tweet object 1, tweet object 2, ...}]
    {:ok,_} = :mnesia.create_table(mentions, [attributes: [:mention, :tweets]])
    {:ok,_} = :mnesia.create_table(social_graph, [attributes: [:id, :followed_by]])
    # :ets.new(:wrapper, [
    #   :set,
    #   :public,
    #   :named_table,
    #   {:read_concurrency, true},
    #   {:write_concurrency, true}
    # ])

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
    :mnesia.write({User, 4, "Marge Simpson", "home maker"})
    # :ets.insert(:wrapper, {key, value})
    -> :ok
  end
end
