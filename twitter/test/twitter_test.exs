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
  # setup_all do
  #   for i <- [1..10], do: Engine.join_twitter("myusername"+Integer.to_string(i))
  #   for i <- [1..10] do # everyone follows 3 random ppl
  #     Engine.follow_user("myusername"+Integer.to_string(i), :rand.uniform(10))
  #     Engine.follow_user("myusername"+Integer.to_string(i), :rand.uniform(10))
  #     Engine.follow_user("myusername"+Integer.to_string(i), :rand.uniform(10))
  #   end
  #   for i <- [1..9], do: Engine.receive_tweet("mentioning @username"+Integer.to_string(:rand.uniform(10))+"and twweting about #hashtag"+Integer.to_string(:rand.uniform(10)))
  #   {:ok}
  # end

  test "register new account" do
    assert {_reply, :ok, _state} = Engine.join_twitter("myusername")
  end

  test "Delete account" do
    assert {_reply, :ok, _state} = Engine.join_twitter("myusername")
  end

  test "Send a tweet" do
    # send a tweet with hashtags and mentions
    assert {_reply, :ok, _state} = Engine.receive_tweet("OMG #ThaBadApple is nuts. Check it @myusername1 #gottaseethis !!")
  end

  test "Subscribe to a user's tweets" do
    assert {_reply, :ok, _state} = Engine.follow_user("myusername1", "myusername2")
  end

  test "Re-tweet" do
    assert false
    # assert {_reply, :ok, _state} = Engine.retweet(uid, tweet_id) # TODO fix this
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
