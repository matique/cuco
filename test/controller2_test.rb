require "test_helper"

describe Controller do
  let(:controller) { Controller.instance }

  def setup
    R.result = +""
    G.init
    Script.load <<~RUBY
      watch("file")            { R.result << "n" }
      watch("file", :added)    { R.result << "a" }
      watch("file", :modified) { R.result << "m" }
    RUBY
  end

  def teardown
    controller.stop
    Script.reset
  end

  it "fails with unknown what pattern" do
    controller.send(:run_file, "fail", nil)
    assert_equal "", R.result
  end

  it "considers event_type nil" do
    check nil, "n"
  end

  it "considers event_type :added" do
    check :added, "na"
  end

  it "considers event_type :modified" do
    check :modified, "nm"
  end

  it "receives a matchdata" do
    Script.load "watch('ab(.)') { |m|
      R.result << m[0]
      R.result << m[1]
    }"

    controller.send(:run_file, "abc", nil)
    assert_equal "abcc", R.result
  end

  it "executes matching callbacks in registration order" do
    Script.load <<~RUBY
      watch("abc") { R.result << "1" }
      watch("abc") { R.result << "2" }
    RUBY

    controller.send(:run_file, "abc")

    assert_equal "12", R.result
  end

  private

  def check(type, expected)
    controller.send(:run_file, "file", type)
    assert_equal expected, R.result
  end
end
