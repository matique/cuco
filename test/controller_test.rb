require "test_helper"

describe Controller do
  let(:cntrl) { Controller.instance }
  let(:regexp) { '.*\.rb' }

  def setup
    G.init({}, [])
  end

  def teardown
    cntrl.stop
  end

  it "stops" do
    cntrl.stop
    assert_nil cntrl.listener
  end

  it "runs" do
    assert_raises(Timeout::Error) do
      Timeout.timeout(0.1) { cntrl.run }
    end

    assert cntrl.listener
  end

  it "read .watchr" do
    assert_raises(Timeout::Error) do
      Timeout.timeout(0.1) { cntrl.run }
    end
  end

  it "run" do
    G.script = Script.new "watch('#{regexp}') { raise IOError }"

    assert_raises(IOError) { cntrl.file_run "a.rb" }
  end

  it "does not run" do
    G.script = Script.new "watch('#{regexp}') { raise IOError }"

    cntrl.file_run "a.no"
  end

  it "receives a matchdata" do
    G.script = Script.new "watch('ab(.)') { |m| [m[0], m[1]] }"

    rule = G.script.__rules.last
    assert_equal ["abc", "c"], cntrl.match_run(rule, "abc")
  end
end
