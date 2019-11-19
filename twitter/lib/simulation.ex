defmodule Simulation do

  #Do full network temporarily
  #def build_social_graph(clients) do build_social_graph(clients, clients) end
  #def build_social_graph([], _clients) do :done end
  #def build_social_graph([hd | tl], clients) do
  #  follow_others(hd, clients -- [hd])
  #  build_social_graph(tl, clients)
  #end

  #def follow_others(_hd, []) do :done end
  #def follow_others(hd, [frst | others]) do
  #  frst_uid = elem(Map.fetch(frst, :uid), 1)
  #  Client.request_follow_user(hd, frst_uid)
  #  follow_others(hd, [others])
  #end

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
