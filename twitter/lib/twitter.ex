defmodule Twitter do

  def start(_type, _args) do
    :observer.start
    [num_clients_str, num_messages_str] = System.argv()
    {num_clients, ""} = Integer.parse(num_clients_str)
    {num_messages, ""} = Integer.parse(num_messages_str)
    MyDynamicSupervisor.start_link()
    MyDynamicSupervisor.start_engine()
    clients = MyDynamicSupervisor.start_clients(num_clients)# Returns list of users: user = %{uid, pid}
    Client.request_join_twitter(clients)
    Simulation.build_social_graph(clients)
    Simulation.run(clients, num_messages)

    #[a, b | _c] = clients
    #loop(10000000) # otherwise query will timeout
    #IO.inspect(Client.request_query_timeline(a))
    #IO.inspect(Client.request_query_timeline(b))
    #IO.inspect(Client.request_query_hashtag(a, "#Hashtag1"))

    :ok
  end

  def loop(0) do :done end
  def loop(num) do loop(num - 1) end

end
