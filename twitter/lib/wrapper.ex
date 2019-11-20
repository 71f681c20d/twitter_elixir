defmodule Wrapper do # wraps a centralized ETS instance

  def init do
    :mnesia.create_schema([node()])
    :mnesia.start
    # A tweet object is like this: tweet = {user1, "mytweet #hello @user2", {#hello}, {@user2}}
    {_, :ok} = :mnesia.create_table(Hashtags, [  attributes: [:hashtag, :tweets], type: :set]) # [#i_luv_twitter, {tweet object 1, tweet object 2, ...}]
    # {_, :ok} = :mnesia.create_table(Mentions, [  attributes: [:hashtag, :tweets], type: :set]) # [#i_luv_twitter, {tweet object 1, tweet object 2, ...}]
    {_, :ok} = :mnesia.create_table(Tweets, [ attributes: [:tweet_id, :uid, :msg], type: :set])
    {_, :ok} = :mnesia.create_table(Users, [ attributes: [:uid, :pid, :followers, :timeline, :mentions], type: :set])
    :ok
  end

  # Manipilate Users table
  def create_user(user) do
    uid = elem(Map.fetch(user, :uid), 1)
    pid = elem(Map.fetch(user, :pid), 1)
    :mnesia.transaction( fn -> :mnesia.write({Users, uid, pid, [], [], []}) end)
  end

  def add_follower(uid_origin, uid_follows) do
    [{Users, uid, pid, followers, timeline, mentions}] = elem(:mnesia.transaction( fn -> :mnesia.match_object({Users, uid_follows, :_, :_, :_, :_}) end), 1)
    :mnesia.transaction( fn -> :mnesia.delete({Users, uid, :_, :_, :_, :_}) end)
    followers = [uid_origin | followers]
    :mnesia.transaction( fn -> :mnesia.write({Users, uid, pid, followers, timeline, mentions}) end)
  end

  def add_timeline(uid, tweet_id) do
    [{Users, uid, pid, followers, timeline, mentions}] = elem(:mnesia.transaction( fn -> :mnesia.match_object({Users, uid, :_, :_, :_, :_}) end), 1)
    :mnesia.transaction( fn -> :mnesia.delete({Users, uid, :_, :_, :_, :_}) end)
    timeline = [tweet_id | timeline]
    :mnesia.transaction( fn -> :mnesia.write({Users, uid, pid, followers, timeline, mentions}) end)
  end

  def add_mention(uid, tweet_id) do
    [{Users, uid, pid, followers, timeline, mentions}] = elem(:mnesia.transaction( fn -> :mnesia.match_object({Users, uid, :_, :_, :_, :_}) end), 1)
    :mnesia.transaction( fn -> :mnesia.delete({Users, uid, :_, :_, :_, :_}) end)
    mentions = [tweet_id | mentions]
    :mnesia.transaction( fn -> :mnesia.write({Users, uid, pid, followers, timeline, mentions}) end)
  end

  def get_user(uid) do :mnesia.transaction( fn -> :mnesia.match_object({Users, uid, :_, :_, :_, :_}) end) end

  # Manipulate Tweets table
  def create_tweet(tweet) do
    tweet_id = elem(Map.fetch(tweet, :tweet_id), 1)
    uid = elem(Map.fetch(tweet, :uid), 1)
    msg = elem(Map.fetch(tweet, :msg), 1)
    :mnesia.transaction(fn ->
      :mnesia.write({Tweets, tweet_id, uid, msg})
    end)
  end

  def get_tweet(tweet_id) do :mnesia.transaction( fn -> :mnesia.match_object({Tweets, tweet_id, :_, :_}) end) end

  # Manipulate Hashtag table

  def query_hashtag(hashtag), do: :mnesia.transaction( fn -> :mnesia.match_object({Hashtags, hashtag, :_}) # returns all tweets containing the hashtag
  def query_mention(hashtag), do: :mnesia.transaction( fn -> :mnesia.match_object({Hashtags, hashtag, :_})
  def query_mention(user), do: :mnesia.transaction( fn -> :mnesia.match_object({Users, :_, :_, :_, :_, user}) end)
end
