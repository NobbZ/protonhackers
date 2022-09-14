defmodule SmokeTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ok =
      :telemetry.attach_many(
        __MODULE__,
        events() ++ SmokeTest.Listener.Supervisor.events() ++ SmokeTest.Protocol.Echo.events(),
        &SmokeTest.TelemetryHandler.handle_event/4,
        []
      )

    children = [
      SmokeTest.Listener.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SmokeTest.Supervisor]

    :telemetry.span(~w[smoke_test boot]a, %{children: children, opts: opts}, fn ->
      {Supervisor.start_link(children, opts), %{}}
    end)
  end

  def events() do
    [
      ~w[smoke_test boot start]a,
      ~w[smoke_test boot stop]a,
      ~w[smoke_test boot exception]a
    ]
  end
end
