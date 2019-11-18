# tapestry_elixir
Twitter implementation in elixir

# Run with
mix run twitter.exs

# DB
User - user_id, Followers (user_ids), Timeline (tweet_ids), Mentions (tweet_ids)
Tweet - tweet_id, user_id, msg
Hashtag - tag_id, Tweets (tweet_ids)