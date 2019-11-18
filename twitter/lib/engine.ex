defmodule Engine do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: Engine)
  end

  def init(state) do
    {:ok, state}
  end

  def join_twitter(user) do GenServer.call(Engine, {:join_twitter, user}) end

  def query_timeline(user) do GenServer.call(Engine, {:query_timeline, user}) end

  def query_mentions(user) do GenServer.call(Engine, {:query_mentions, user}) end

  def query_hashtag(hashtag) do GenServer.call(Engine, {:query_hashtag, hashtag}) end

  def receive_tweet(tweet) do GenServer.cast(Engine, {:receive_tweet, tweet}) end

  def follow_user(user_origin, user_follow) do GenServer.cast(Engine, {:follow_request, user_origin, user_follow}) end

  def handle_call({:join_twitter, _user}, _from, state) do
    # TODO Add to list of all users - map with uid and pid
    IO.puts 'called'
    {:reply, :ok, state}
  end

  def handle_call({:query_timeline, _user}, _from, state) do
    # TODO get timeline for uid in user
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
    push_to_followers(tweet)
    {:ok, msg} = Map.fetch(tweet, :msg)
    # TODO test regex on msg for hashtag and @
    {:noreply, state}
  end

  def handle_cast({:follow_request, _user_origin, _user_follow}, state) do
    # TODO add user_origin to user_follows list of followers
    {:noreply, state}
  end

  def push_to_followers(tweet) do
    # TODO get followers for Tweet.user, Add to followers timeline in db, If followers online push tweet
    :ok
  end

  def push_to_hashtags(hashtag, tweet) do
    # TODO add to hashtag db
    :ok
  end

  def push_to_mentions(mentioned_user, tweet) do
    # TODO add to mentions db
    # If mentioned user online push straight to client
    :ok
  end
end
