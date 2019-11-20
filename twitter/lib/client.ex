defmodule Client do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__,  %{})
  end

  def init(state) do
    {:ok, state}
  end

  # These are wrappers so that we can make sure that the request to the engine originates from the correct client
  def request_join_twitter([hd | tl]) do
    request_join_twitter(hd)
    request_join_twitter(tl)
  end
  def request_join_twitter([]) do :done end
  def request_join_twitter(user) do
    pid = elem(Map.fetch(user, :pid), 1)
    GenServer.call(pid, {:request_join_twitter, user})
  end

  def request_delete_user(user) do
    pid = elem(Map.fetch(user, :pid), 1)
    GenServer.call(pid, {:request_delete_twitter, user})
  end

  def request_query_timeline(user) do
    pid = elem(Map.fetch(user, :pid), 1)
    GenServer.call(pid, {:request_query_timeline, user})
  end

  def request_query_mentions(user) do
    pid = elem(Map.fetch(user, :pid), 1)
    GenServer.call(pid, {:request_query_mentions, user})
  end

  def request_query_hashtag(user, hashtag) do
    pid = elem(Map.fetch(user, :pid), 1)
    GenServer.call(pid, {:request_query_mentions, hashtag})
  end

  def request_follow_user(user_origin, user_follow) do
    pid = elem(Map.fetch(user_origin, :pid), 1)
    GenServer.cast(pid, {:request_follow_user, user_origin, user_follow})
  end

  def receive_live_tweet(pid, tweet) do
    GenServer.cast(pid, {:live_tweet, tweet})
  end

  def request_make_tweet(user, tweet) do
    pid = elem(Map.fetch(user, :pid), 1)
    GenServer.cast(pid, {:request_make_tweet, tweet})
  end

  # These forward on the request to the Engine
  def handle_call({:request_join_twitter, user}, _from, state) do
    rep = Engine.join_twitter(user)
    {:reply, rep, state}
  end

  def handle_call({:request_delete_twitter, user}, _from, state) do
    Engine.delete_twitter(user)
    {:reply, :ok, state}
  end

  def handle_call({:request_query_timeline, user}, _from, state) do
    rep = Engine.query_timeline(user)
    {:reply, rep, state}
  end

  def handle_call({:request_query_mentions, user}, _from, state) do
    rep = Engine.query_mentions(user)
    {:reply, rep, state}
  end

  def handle_call({:request_query_hashtag, hashtag}, _from, state) do
    rep = Engine.query_hashtag(hashtag)
    {:reply, rep, state}
  end

  def handle_cast({:request_follow_user, user_origin, user_follow}, state) do
    Engine.follow_user(user_origin, user_follow)
    {:noreply, state}
  end

  def handle_cast({:request_make_tweet, tweet}, state) do
    Engine.receive_tweet(tweet)
    {:noreply, state}
  end

  def handle_cast({:live_tweet, _tweet}, state) do
    # Receives tweet on client
    {:noreply, state}
  end

end
