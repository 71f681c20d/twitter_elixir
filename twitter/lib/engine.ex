defmodule Engine do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: Engine)
  end

  def init(state) do
    Wrapper.init()
    {:ok, state}
  end

  def join_twitter(user) do GenServer.call(Engine, {:join_twitter, user}) end

  def query_timeline(user) do GenServer.call(Engine, {:query_timeline, user}) end

  def query_mentions(user) do GenServer.call(Engine, {:query_mentions, user}) end

  def query_hashtag(hashtag) do GenServer.call(Engine, {:query_hashtag, hashtag}) end

  def receive_tweet(tweet) do GenServer.cast(Engine, {:receive_tweet, tweet}) end

  def follow_user(user_origin, user_follow) do GenServer.cast(Engine, {:follow_request, user_origin, user_follow}) end

  #Adds uid, pid and empty follower list to Users table
  def handle_call({:join_twitter, user}, _from, state) do
    Wrapper.create_user(user)
    {:reply, :ok, state}
  end

  def handle_call({:query_timeline, _user}, _from, state) do
    # TODO get timeline for uid in user
    # dbms_pid = elem(Map.fetch(from, :pid), 1)
    {:reply, :ok, state}
  end

  def handle_call({:query_mentions, _user}, _from, state) do
    # TODO get mentions of timeline from uid of user
    {:reply, :ok, state}
  end

  def handle_call({:query_hashtag, _hashtag}, _from, state) do
    # TODO get tweet list with hastag uid
    {:reply, :ok, state}
  end

  def handle_cast({:receive_tweet, tweet}, state) do
    # TODO Add tweet to tweet database, push to followers, mentions, and hashtags
    IO.puts 'received tweet'
    IO.inspect(tweet)
    tweeter_id = elem(Map.fetch(tweet, :uid), 1)
    tweeter = Wrapper.get_user(tweeter_id)
    IO.inspect(tweeter)
    {:noreply, state}
  end

  # Updates user_follow in Users tables, add user_origin uid to followers
  def handle_cast({:follow_request, user_origin, user_follow}, state) do
    uid_origin = elem(Map.fetch(user_origin, :uid), 1)
    Wrapper.add_follower(uid_origin, user_follow)
    {:noreply, state}
  end

end
