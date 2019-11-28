defmodule Simulation do

  # Build out followers for each user.
  # Build celebrity users with lots of followers

  # If user marked celebrity higher chance to follow them
  # If user follows you higher chance to follow them
  def build_social_graph(clients) do build_social_graph(clients, clients) end
  def build_social_graph([], _clients) do :done end
  def build_social_graph([hd | tl], clients) do
    clients = create_celebrities(clients)
    follow_users(hd, clients)
    build_social_graph(tl, clients)
  end

  def create_celebrities(list) do create_celebrities(list, []) end
  def create_celebrities([], list) do list end
  def create_celebrities([hd | tl], done) do
    num = :rand.uniform(99)
    cond do
      num > 93 ->
        hd = Map.put(hd, :celeb, :true)
        create_celebrities(tl, [hd | done])
      true ->
        hd = Map.put(hd, :celeb, :false)
        create_celebrities(tl, [hd | done])
    end
  end

  def follow_users(_follower, []) do :done end
  def follow_users(follower, [hd | tl]) do
    celeb = elem(Map.fetch(hd, :celeb), 1)
    case celeb do
      :true ->
        do_follow(follower, 40, hd)
      :false ->
        do_follow(follower, 90, hd)
    end
    follow_users(follower, tl)
  end

  def do_follow(follower, chance, user) do
    num = :rand.uniform(100)
    cond do
      num > chance ->
        Client.request_follow_user(follower, user)
      true ->
        :done
    end
  end

  #Run send_msg num_msg times for each client in list
  def run(clients, num_msgs) do run(clients, num_msgs, clients) end
  def run([], _num_msgs, _clients) do :done end
  def run([hd | tl], num_msgs, clients) do
    send_messages(hd, num_msgs, clients -- [hd])
    run(tl, num_msgs, clients)
  end

  #Send msg num_msg times from specific client
  def send_messages(_client, 0, _other_clients) do :done end
  def send_messages(client, num_messages, other_clients) do
    uid = elem(Map.fetch(client, :uid), 1)
    my_msg = generate_tweet_msg(other_clients)
    tweet = %{uid: uid, msg: my_msg}
    Client.request_make_tweet(client, tweet)
    send_messages(client, num_messages-1, other_clients)
  end

  #Generate tweet message content
  def generate_tweet_msg(other_clients) do
    hashtags = ["#Hashtag1", "#Hashtag2", "#Hashtag3", "#Hashtag4"]
    options = [0, 1, 2, 3] # 0 = txt, 1 = txt and #, 2 = txt and @, 3 =txt and # and @

    msg = "Hello World"
    opt = Enum.random(options)
    case opt do
      0 ->
        msg
      1 ->
        hashtag = Enum.random(hashtags)
        Enum.join([msg, hashtag], " ")
      2 ->
        mention = Enum.join(["@", elem(Map.fetch(Enum.random(other_clients), :uid), 1)], "")
        Enum.join([msg, mention], " ")
      3 ->
        mention = Enum.join(["@", elem(Map.fetch(Enum.random(other_clients), :uid), 1)], "")
        hashtag = Enum.random(hashtags)
        Enum.join([msg, hashtag, mention], " ")
    end
  end
end
