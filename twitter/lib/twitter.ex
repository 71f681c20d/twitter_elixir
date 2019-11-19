defmodule Twitter do

  def start(_type, _args) do
    :observer.start
    num_clients = 20
    num_messages = 2
    MyDynamicSupervisor.start_link()
    MyDynamicSupervisor.start_engine()
    clients = MyDynamicSupervisor.start_clients(num_clients)# Returns list of users: user = %{uid, pid}
    Client.request_join_twitter(clients)



    #Simulation.build_social_graph(clients)
    [a | _tl] = clients
    Client.request_follow_user(a, "2")
    loop(1000000)
    Simulation.run(clients, num_messages)
    loop(1000000)
    IO.inspect(Wrapper.get_user("1")) #a
    IO.inspect(Wrapper.get_user("2"))
    IO.inspect(Client.request_query_timeline(a))
    #IO.puts '---'
    #IO.inspect(Wrapper.get_user("2"))
    #IO.puts '---'
  end

  def loop(0) do :done end
  def loop(num) do loop(num - 1) end

end
