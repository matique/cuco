require "test_helper"

describe Controller do
  let(:cuco) { Controller.instance }
  let(:regexp) { '.*\.rb' }

  def setup
    G.init({}, [])
  end

  def teardown
    cuco.stop
  end

  it "stops" do
    cuco.stop
    assert_nil cuco.listener
  end

  it "runs" do
    assert_raises(Timeout::Error) do
      Timeout.timeout(0.1) { cuco.run }
    end

    assert cuco.listener
  end

  it "read .watchr" do
    assert_raises(Timeout::Error) do
      Timeout.timeout(0.1) { cuco.run }
    end
  end

  it "run" do
    G.script = Script.new "watch('#{regexp}') { raise IOError }"

    assert_raises(IOError) { cuco.file_run "a.rb" }
  end

  it "does not run" do
    G.script = Script.new "watch('#{regexp}') { raise IOError }"

    cuco.file_run "a.no"
  end

  it "receives a matchdata" do
    G.script = Script.new "watch('ab(.)') { |m| [m[0], m[1]] }"

    rule = G.script.__rules.last
    assert_equal ["abc", "c"], cuco.match_run(rule, "abc")
  end
end
