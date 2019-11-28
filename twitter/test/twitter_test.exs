defmodule TwitterTest do
  use ExUnit.Case
  doctest Twitter

  @doc """
  Unit Tests:
    Register new account
    Delete account
    Send a tweet
    Subscribe to a user's tweets
    Re-tweet
    Query tweets:
      Subscribed-to
      Hashtag
      Mention
    Deliver twwets live if the user is connected
  """

  setup_all do
    MyDynamicSupervisor.start_link()
    Engine.start_link()
    Wrapper.init()
    lst = MyDynamicSupervisor.start_clients(2);
    [a, b] = lst
    Client.request_join_twitter(a)
    Client.request_join_twitter(b)
    {:ok, clients: lst}
  end

  test "register new account" do
    user = %{pid: 'somepid', uid: 'myusername'}
    status = Engine.join_twitter(user)
    assert status == :created
  end

  test "Delete account" do
    user = %{pid: 'somepid', uid: 'myusername2'}
    Engine.join_twitter(user)
    Engine.delete_twitter(user)
    [{Users, _uid, pid, _followers, _timeline, _mentions}] = elem(Wrapper.get_user('myusername2'), 1)
    assert nil == pid
  end

  test "Follow user", state do
    [a, b | _tl] = state[:clients]
    Client.request_follow_user(a, b)
    Twitter.loop(1000000) #Give time for cast to finish
    [{Users, _uid, _pid, followers, _timeline, _mentions}] = elem(Wrapper.get_user(elem(Map.fetch(b, :uid), 1)), 1)
    assert followers == ["1"]
  end

  test "Receive tweet from following", state do
    [a, b | _tl] = state[:clients]
    Client.request_follow_user(b, a)
    tweet = %{uid: "1", msg: "Hello World"}
    Client.request_make_tweet(a, tweet)
    Twitter.loop(1000000) #Give time for cast to finish
    [atomic: [{Tweets, _tweet_id, _uid, msg}]] = Client.request_query_timeline(b)
    # Do this because tweet_id might change based on order of tests
    assert msg == "Hello World"
  end
 
  test "Hashtags", state do
    [a | _tl] = state[:clients]
    tweet = %{uid: "2", msg: "Hello Tester #TESTING"}
    Client.request_make_tweet(a, tweet)
    [atomic: [{Tweets, _tweet_id, _uid, msg}]] = Client.request_query_hashtag(a, "#TESTING")
    # Do this because tweet_id might change based on order of tests
    assert msg == "Hello Tester #TESTING"
  end

  test "Mentions", state do
    [a, b | _tl] = state[:clients]
    tweet = %{uid: "2", msg: "Hello Tester @1"}
    Client.request_make_tweet(b, tweet)
    [atomic: [{Tweets, _tweet_id, _uid, msg}]] = Client.request_query_mentions(a)
    # Do this because tweet_id might change based on order of tests
    assert msg == "Hello Tester @1"
  end
end
