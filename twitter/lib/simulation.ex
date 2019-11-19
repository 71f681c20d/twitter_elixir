defmodule Simulation do
  def build_social_graph(clients) do
    :ok
  end

  #Send expected number of tweets on network
  def run([], _num_msgs) do :done end
  def run([hd | tl], num_msgs) do
    send_messages(hd, num_msgs, tl)
    run(tl, num_msgs)
  end

  def send_messages(_client, 0, other_clients) do :done end
  def send_messages(client, num_messages, other_clients) do
    uid = elem(Map.fetch(client, :uid), 1)
    my_msg = generate_tweet_msg(other_clients)
    tweet = %{uid: uid, msg: my_msg}
    Client.request_make_tweet(client, tweet)
    send_messages(client, num_messages-1, other_clients)
  end

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
