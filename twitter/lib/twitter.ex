defmodule Twitter do
  @moduledoc """
  Twitter implementation in Elixir for COP5615.
  """

  def start(_type, _args) do
    args = System.argv()

    :observer.start
    #args = ["100", "3"]
    case args do
      [num_nodes, num_requests] ->
        num_nodes = String.to_integer(num_nodes)
        num_requests = String.to_integer(num_requests)
        Tapestry.DynamicSupervisor.start_link(args)
        listener = elem(Tapestry.DynamicSupervisor.start_listener(num_nodes * num_requests), 1)
        nodes = Tapestry.DynamicSupervisor.start_children(num_nodes, [])
        [hd | tl] = nodes
        Enum.map(tl, fn x -> init_tapestry(x, hd) end)                                            # Pick the first node to join everyone else
          Enum.map(nodes, fn x -> do_message(x, nodes, num_requests, listener) end)                 # Send a message from eavry other node
          IO.inspect(args)
          loop(num_nodes + 1) #TODO Busy wait not ideal
      _ ->
        IO.puts 'Invalid arguments please put args: numNodes numRequests'
      end
  end

end
