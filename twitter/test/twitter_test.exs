defmodule TwitterTest do
  use ExUnit.Case
  doctest Twitter

  test "greets the world" do
    assert Twitter.hello() == :world
  end

  test "tweet added to followers timeline db" do
    #[a, b, c, d | tl] = clients
    #Client.request_follow_user(a, b)
    #Client.request_make_tweet(b, %{user:b, msg:"Hello A"})
    #assert Client.request_query_timeline(a) == ["Hello A"]
  end
end
