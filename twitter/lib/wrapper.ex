defmodule Wrapper do # wraps a centralized ETS instance

  def init(arg) do
    :mnesia.create_schema([node()])
    :mnesia.start
    # A tweet object is like this: tweet = {user1, "mytweet #hello @user2", {#hello}, {@user2}}
    {_, :ok} = :mnesia.create_table(:hashtags, [  attributes: [:hashtag, :tweets], type: :set]) # [#i_luv_twitter, {tweet object 1, tweet object 2, ...}]
    {_, :ok} = :mnesia.create_table(:mentions, [ attributes: [:mention, :tweets], type: :set])
    {_, :ok} = :mnesia.create_table(:social_graph, [ attributes: [:id, :followed_by], type: :set])
    {:ok, arg}
  end

  def get_hashtags(pid, key), do: get(key, :hashtags)
  def get_mentions(pid, key), do: get(key, :mentions)
  def get_social_graph(pid, key), do: get(key, :social_graph)

  def get(pid, key, table) do
    {_, message} = :mnesia.transaction(fn -> :mnesia.read({table, key}) end)
    message
  end

  def put_hashtags(pid, key, value), do: put(key, value, :hashtags)
  def put_mentions(pid, key, value), do: put(key, value, :mentions)
  def put_social_graph(pid, key, value), do: put(key, value, :social_graph)

  def put(key, value, table) do
    {_, message} = :mnesia.transaction(fn -> :mnesia.write({table, key, value}) end)
    message
  end

end
