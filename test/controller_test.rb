require "test_helper"

describe Controller do
  let(:cntrl) { Controller.instance }
  let(:regexp) { '.*\.rb' }

  def setup
    G.init
  end

  def teardown
    Script.reset
    cntrl.stop
  end

  it "stops" do
    cntrl.stop

    assert_nil cntrl.listener
  end

  it "propagates callback exceptions" do
    Script.load "watch('#{regexp}') { raise IOError }"

    assert_raises(IOError) do
      cntrl.send(:run_file, "a.rb")
    end
  end

  it "does not execute nonmatching rules" do
    Script.load "watch('#{regexp}') { raise IOError }"

    cntrl.send(:run_file, "a.txt")
  end

  it "can stop multiple times" do
    cntrl.stop
    cntrl.stop

    assert_nil cntrl.listener
  end
end
