defmodule SmokeTest.TelemetryHandler do
  require Logger

  def handle_event(
        ~w[smoke_test boot start]a,
        _measurements,
        %{children: childs, opts: opts},
        _config
      ) do
    Logger.info("Application boot begins")
    Logger.info("children: #{inspect(childs)}")
    Logger.info("opts    : #{inspect(opts)}")
  end

  def handle_event(~w[smoke_test boot stop]a, %{duration: duration}, _metadata, _config) do
    duration_ms = to_milli(duration)
    Logger.info("Application booted in #{duration_ms}ms")
  end

  def handle_event(
        ~w[smoke_test listener supervisor start]a,
        _meas,
        %{children: childs, opts: opts},
        _conf
      ) do
    Logger.info("Listener supervisor boot begins")
    Logger.info("children: #{inspect(childs)}")
    Logger.info("opts    : #{inspect(opts)}")
  end

  def handle_event(
        ~w[smoke_test listener supervisor stop]a,
        %{duration: duration},
        _metadata,
        _config
      ) do
    duration_ms = to_milli(duration)
    Logger.info("Application booted in #{duration_ms}ms")
  end

  def handle_event(~w[smoke_test echo start]a, _meas, _meta, _conf) do
    Logger.info("Echoing connection begins")
  end

  def handle_event(
        ~w[smoke_test echo stop]a,
        %{duration: duration},
        _metadata,
        _config
      ) do
    duration_ms = to_milli(duration)
    Logger.info("Echoing connection finished in #{duration_ms}ms")
  end

  def handle_event(~w[smoke_test echo send start]a, _meas, _meta, _conf) do
    Logger.info("Sending echo reply")
  end

  def handle_event(
        ~w[smoke_test echo send stop]a,
        %{duration: duration},
        %{sent: sent},
        _config
      ) do
    duration_ms = to_milli(duration)
    Logger.info("Sent #{sent} bytes in #{duration_ms}ms")
  end

  def handle_event(event, measurements, metadata, _config) do
    Logger.warn(
      "An unknown event occured: #{inspect(event)}. meas: #{inspect(measurements)}; meta: #{inspect(metadata)}"
    )
  end

  defp to_milli(duration),
    do: System.convert_time_unit(duration, :native, :millisecond)
end
