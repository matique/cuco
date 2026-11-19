require "test_helper"

describe Controller do
  let(:controller) { Controller.instance }
  let(:regexp) { '.*\.rb' }

  def setup
    G.init
  end

  def teardown
    Script.reset
    controller.stop
  end

  describe "#stop" do
    it "stops the listener" do
      controller.stop

      assert_nil controller.listener
    end

    it "can be called multiple times" do
      controller.stop
      controller.stop

      assert_nil controller.listener
    end
  end

  describe "#run_file" do
    it "propagates callback exceptions" do
      Script.load "watch('#{regexp}') { raise IOError }"

      assert_raises(IOError) do
        controller.send(:run_file, "a.rb")
      end
    end

    it "does not execute nonmatching rules" do
      Script.load "watch('#{regexp}') { raise IOError }"

      controller.send(:run_file, "a.txt")
    end
  end
end
