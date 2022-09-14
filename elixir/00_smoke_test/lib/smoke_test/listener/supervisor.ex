defmodule SmokeTest.Listener.Supervisor do
  use Supervisor

  alias SmokeTest.Listener.Echo

  def start_link(args), do: Supervisor.start_link(__MODULE__, [{:name, __MODULE__} | args])

  @impl Supervisor
  def init(_args) do
    children = [{Echo, [:inet6, port: 5555]}]
    opts = [strategy: :one_for_one]

    :telemetry.span(~w[smoke_test listener supervisor]a, %{children: children, opts: opts}, fn ->
      {Supervisor.init(children, opts), %{}}
    end)
  end

  def events() do
    [
      ~w[smoke_test listener supervisor start]a,
      ~w[smoke_test listener supervisor stop]a,
      ~w[smoke_test listener supervisor exception]a
    ]
  end
end
