defmodule Helper do

  # Add tweet to all of the tweeters followers timelines
  def push_to_followers(tweet) do
    tweet_id = elem(Map.fetch(tweet, :tweet_id), 1)
    [{Users, _uid, _pid, followers, _timeline}] = elem(Wrapper.get_user(elem(Map.fetch(tweet, :uid), 1)), 1)
    push_to_followers(followers, tweet_id)
  end
  def push_to_followers([], _tweet_id) do :done end
  def push_to_followers([hd | tl], tweet_id) do
    Wrapper.add_timeline(hd, tweet_id)
    push_to_followers(tl, tweet_id)
  end

  # Get list of tweets corresponding to list of tweet_ids
  def get_tweets_of_timeline(timeline) do get_tweets_of_timeline(timeline, []) end
  def get_tweets_of_timeline([], tweets) do tweets end
  def get_tweets_of_timeline([hd | tl], tweets) do
    tweets = [Wrapper.get_tweet(hd) | tweets]
    get_tweets_of_timeline(tl, tweets)
  end

end
