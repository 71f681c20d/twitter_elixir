defmodule Wrapper do # wraps a centralized ETS instance
  use GenServer

  def init(arg) do
    :mnesia.create_schema([node()])
    :mnesia.start
    # A tweet object is like this: tweet = {user1, "mytweet #hello @user2", {#hello}, {@user2}}
    {_, :ok} = :mnesia.create_table(:hashtags, [  attributes: [:hashtag, :tweets], type: :set]) # [#i_luv_twitter, {tweet object 1, tweet object 2, ...}]
    {_, :ok} = :mnesia.create_table(:mentions, [ attributes: [:mention, :tweets], type: :set])
    {_, :ok} = :mnesia.create_table(:social_graph, [ attributes: [:id, :followed_by], type: :set])

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
    # TODO: initialize schema for DBMS
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def get_hashtags(key), do: get(key, :hashtags)
  def get_mentions(key), do: get(key, :mentions)
  def get_social_graph(key), do: get(key, :social_graph)

  def get(key, table) do
    # from_pid = elem(Map.fetch(from, :pid), 1)
    GenServer.cast(self, {:get, key, table})
  end

  def handle_cast({:get, key, table}, state) do
    :mnesia.read({table, key})
  end

  def put_hashtags(key, value), do: put(key, value, :hashtags)
  def put_mentions(key, value), do: put(key, value, :mentions)
  def put_social_graph(key, value), do: put(key, value, :social_graph)

  def put(key, value, table) do
    # from_pid = elem(Map.fetch(from, :pid), 1)
    GenServer.call(self, {:put, key, value, table})
  end

  def handle_call({:put, key, value, table}, state) do
    :mnesia.write({table, key, value})
    :ok
  end
end
