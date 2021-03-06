defmodule Toniq.JobTest do
  use ExUnit.Case

  defmodule SomeWorker do
  end

  test "builds a job without options" do
    job = Toniq.Job.build(42, SomeWorker, %{some: "data"})

    assert job == %{id: 42, worker: SomeWorker, arguments: %{some: "data"}, version: 1}
  end

  test "builds a job with a delay" do
    job = Toniq.Job.build(42, SomeWorker, %{some: "data"}, delay_for: 3_000)
    expiry = :os.system_time(:milli_seconds) + 3_000

    assert job.id == 42
    assert job.worker == SomeWorker
    assert job.arguments == %{some: "data"}
    assert job.version == 1
    assert_in_delta(job.delayed_until, expiry, 10)
  end
end
