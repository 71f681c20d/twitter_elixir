defmodule Engine do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{tweet_id: 1000}, name: Engine)
  end

  def init(state) do
    {:ok, state}
  end

  def join_twitter(user) do
    GenServer.call(Engine, {:join_twitter, user})
  end

  def delete_twitter(user) do GenServer.call(Engine, {:delete_twitter, user}) end

  def query_timeline(user) do GenServer.call(Engine, {:query_timeline, user}) end

  def query_mentions(user) do GenServer.call(Engine, {:query_mentions, user}) end

  def query_hashtag(hashtag) do GenServer.call(Engine, {:query_hashtag, hashtag}) end

  def receive_tweet(tweet) do GenServer.cast(Engine, {:receive_tweet, tweet}) end

  def follow_user(user_origin, user_follow) do GenServer.cast(Engine, {:follow_request, user_origin, user_follow}) end

  def retweet(uid, tweet_id) do GenServer.cast(Engine, {:retweet, uid, tweet_id}) end


  #Adds uid, pid and empty follower list to Users table
  def handle_call({:join_twitter, user}, _from, state) do
    res = Wrapper.create_user(user)
    {:reply, res, state}
  end

  def handle_call({:delete_twitter, user}, _from, state) do
    Wrapper.delete_user(user)
    {:reply, :ok, state}
  end

  def handle_call({:query_timeline, user}, _from, state) do
    [{Users, _uid, _pid, _followers, timeline, _mentions}] = elem(Wrapper.get_user(elem(Map.fetch(user, :uid), 1)), 1)
    tweets = Helper.get_tweets_of_list(timeline)
    {:reply, tweets, state}
  end

  def handle_call({:query_mentions, user}, _from, state) do
    [{Users, _uid, _pid, _followers, _timeline, mentions}] = elem(Wrapper.get_user(elem(Map.fetch(user, :uid), 1)), 1)
    tweets = Helper.get_tweets_of_list(mentions)
    {:reply, tweets, state}
  end

  def handle_call({:query_hashtag, hashtag}, _from, state) do
    [{Hashtags, _hashtag, hashtag_tweet_ids}] = elem(Wrapper.query_hashtag(hashtag), 1)
    tweets = Helper.get_tweets_of_list(hashtag_tweet_ids)
    {:reply, tweets, state}
  end

  def handle_cast({:receive_tweet, tweet}, state) do
    current_tweet_id = elem(Map.fetch(state, :tweet_id), 1)
    tweet = Map.put(tweet, :tweet_id, current_tweet_id)
    state = Map.put(state, :tweet_id, current_tweet_id + 1)
    Wrapper.create_tweet(tweet)
    Helper.push_to_followers(tweet)
    Helper.regex_hashtag(tweet)
    Helper.regex_mention(tweet)
    {:noreply, state}
  end

  # Updates user_follow in Users tables, add user_origin uid to followers
  def handle_cast({:follow_request, user_origin, user_follow}, state) do
    uid_origin = elem(Map.fetch(user_origin, :uid), 1)
    Wrapper.add_follower(uid_origin, user_follow)
    {:noreply, state}
  end

  def handle_cast({:retweet, uid, tweet_id}, state) do
    Helper.push_retweet(uid, tweet_id)
    {:noreply, state}
  end
end
