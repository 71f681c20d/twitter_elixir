defmodule Twitter do

  def start(_type, _args) do
    :observer.start
    num_clients = 20
    num_messages = 2
    MyDynamicSupervisor.start_link()
    MyDynamicSupervisor.start_engine()
    clients = MyDynamicSupervisor.start_clients(num_clients)# Returns list of users: user = %{uid, pid}
    #Client.request_join_twitter(clients)
    [a, b | c] = clients
    IO.inspect(Client.request_join_twitter(a))
    IO.inspect(Client.request_join_twitter(b))
    loop(100000)
    IO.puts 'loop done'
    Client.request_follow_user(a, b)
    #Simulation.build_social_graph(clients)
    #Simulation.run(clients, num_messages)
  end

  def loop(0) do :done end
  def loop(num) do loop(num - 1) end

end
