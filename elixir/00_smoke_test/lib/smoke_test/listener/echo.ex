defmodule SmokeTest.Listener.Echo do
  alias SmokeTest.Protocol.Echo, as: EchoProtocol

  def child_spec(opts) do
    :ranch.child_spec(__MODULE__, :ranch_tcp, opts, EchoProtocol, [])
  end
end
