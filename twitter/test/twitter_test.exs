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


  test "register new account" do
    assert {_reply, :ok, _state} = Engine.join_twitter("myusername1")
  end

  test "Delete account" do
    assert {_reply, :ok, _state} = Engine.join_twitter("myusername1")
  end

  test "Send a tweet" do
    # send a tweet with hashtags and mentions
    assert {_reply, :ok, _state} = Engine.receive_tweet("OMG #ThaBadApple is nuts. Check it @myusername1 #gottaseethis !!")
  end

  test "Subscribe to a user's tweets" do
    assert {_reply, :ok, _state} = Engine.follow_user("myusername1", "myusername2")
  end

  test "Re-tweet" do
    assert {_reply, :ok, _state} = Engine.retweet(uid, tweet_id) # TODO fix this
  end

  test "query: Subscribed-to" do
    assert {_reply, :ok, _state} = Engine.query_timeline("myusername1")
  end

  test "query: Hashtag" do
    assert {_reply, :ok, _state} = Engine.query_hashtag("#ThaBadApple")
  end

  test "query: Mention" do
    assert {_reply, :ok, _state} = Engine.query_mentions("@myusername1")
  end

  test "Deliver twwets live if the user is connected" do
    # assert {_reply, :ok, _state} =
    assert false
  end



end
