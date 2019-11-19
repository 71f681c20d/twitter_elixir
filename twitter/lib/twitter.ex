defmodule Twitter do

  def start(_type, _args) do
    :observer.start
    num_clients = 20
    num_messages = 10
    MyDynamicSupervisor.start_link()
    MyDynamicSupervisor.start_engine()
    clients = MyDynamicSupervisor.start_clients(num_clients)# Returns list of users: user = %{uid, pid}
    Client.request_join_twitter(clients)
    Simulation.build_social_graph(clients)
    Simulation.run(clients, num_messages)
  end

end
