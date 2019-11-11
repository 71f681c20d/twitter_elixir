defmodule Twitter do

  def start(_type, _args) do
    :observer.start
    num_clients = 20
    #Should this be abstracted away to a master super that supervise engine and dynamic
    MyDynamicSupervisor.start_link()
    MyDynamicSupervisor.start_engine()
    clients = MyDynamicSupervisor.start_clients(num_clients)# Returns list of users: user = %{uid, pid}
    Client.request_join_twitter(clients)
    #TODO Simulation.run
  end

end
