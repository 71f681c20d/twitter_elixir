defmodule Wrapper do # wraps a centralized ETS instance

  def init do
    :mnesia.create_schema([node()])
    :mnesia.start
    # A tweet object is like this: tweet = {user1, "mytweet #hello @user2", {#hello}, {@user2}}
    {_, :ok} = :mnesia.create_table(Hashtags, [  attributes: [:hashtag, :tweets], type: :set]) # [#i_luv_twitter, {tweet object 1, tweet object 2, ...}]
    {_, :ok} = :mnesia.create_table(Mentions, [ attributes: [:mention, :tweets], type: :set])
    {_, :ok} = :mnesia.create_table(Social_Graph, [ attributes: [:id, :followed_by], type: :set])
    {_, :ok} = :mnesia.create_table(Users, [ attributes: [:id, :pid, :followers], type: :set])
    :ok
  end

  def create_user(user) do
    uid = elem(Map.fetch(user, :uid), 1)
    pid = elem(Map.fetch(user, :pid), 1)
    :mnesia.transaction( fn -> :mnesia.write({Users, uid, pid, []}) end)
  end

  def add_follower(uid_origin, uid_follows) do
    [{Users, uid, pid, followers}] = elem(:mnesia.transaction( fn -> :mnesia.match_object({Users, uid_follows, :_, :_}) end), 1)
    :mnesia.transaction( fn -> :mnesia.delete({Users, uid, :_, :_}) end)
    followers = [uid_origin | followers]
    :mnesia.transaction( fn -> :mnesia.write({Users, uid, pid, followers}) end)
  end

  def get_user(uid) do :mnesia.transaction( fn -> :mnesia.match_object({Users, uid, :_, :_}) end) end

  #def get_hashtags(pid, key), do: get(key, :hashtags)
  #def get_mentions(pid, key), do: get(key, :mentions)
  #def get_social_graph(pid, key), do: get(key, :social_graph)

  #def get(pid, key, table) do
  #  {_, message} = :mnesia.transaction(fn -> :mnesia.read({table, key}) end)
  #  message
  #end

  #def put_hashtags(pid, key, value), do: put(key, value, :hashtags)
  #def put_mentions(pid, key, value), do: put(key, value, :mentions)
  #def put_social_graph(pid, key, value), do: put(key, value, :social_graph)

  #def put(key, value, table) do
  #  {_, message} = :mnesia.transaction(fn -> :mnesia.write({table, key, value}) end)
  #  message
  #end

end
