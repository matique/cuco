require "test_helper"

describe Controller do
  let(:cntrl) { Controller.instance }

  def setup
    R.result = "".dup
    G.init
    Script.load <<~EOS
      watch("file")            { R.result << "n" }
      watch("file", :added)    { R.result << "a" }
      watch("file", :modified) { R.result << "m" }
    EOS
  end

  def teardown
    cntrl.stop
  end

  it "fails with unknown what pattern" do
    cntrl.send(:run_file, "fail", nil)
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

    cntrl.send(:run_file, "abc", nil)
    assert_equal "abcc", R.result
  end

  private

  def check(type, expected)
    cntrl.send(:run_file, "file", type)
    assert_equal expected, R.result
  end
end
