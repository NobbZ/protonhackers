defmodule SmokeTest.Protocol.Echo do
  use GenServer

  @behaviour :ranch_protocol
  @timeout 5000

  @impl true
  def start_link(ref, transport, opts) do
    {:ok, :proc_lib.spawn_link(__MODULE__, :init, [{ref, transport, opts}])}
  end

  @impl true
  def init({ref, transport, _opts}) do
    start = :erlang.monotonic_time()

    :telemetry.execute(
      ~w[smoke_test echo start]a,
      %{monotonic_time: start}
    )

    {:ok, socket} = :ranch.handshake(ref)
    :ok = transport.setopts(socket, active: :once)
    :gen_server.enter_loop(__MODULE__, [], {socket, transport, start, 0}, @timeout)
  end

  @impl true
  def handle_info({:tcp, socket, data}, {socket, transport, start, bytes}) do
    received = byte_size(data)

    :ok =
      :telemetry.span(~w[smoke_test echo send]a, %{}, fn ->
        {transport.send(socket, data), %{sent: received}}
      end)

    :ok = transport.setopts(socket, active: :once)
    {:noreply, {socket, transport, start, bytes + received}, @timeout}
  end

  @impl true
  def handle_info({:tcp_closed, socket}, {socket, transport, start, bytes} = state) do
    transport.close(socket)

    stop = :erlang.monotonic_time()

    :telemetry.execute(~w[smoke_test echo stop]a, %{duration: stop - start, transfered: bytes * 2})

    {:stop, :shutdown, state}
  end

  def events() do
    [
      ~w[smoke_test echo start]a,
      ~w[smoke_test echo stop]a,
      ~w[smoke_test echo send start]a,
      ~w[smoke_test echo send stop]a,
      ~w[smoke_test echo send exception]a
    ]
  end
end
