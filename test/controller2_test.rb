require "test_helper"

class R
  class << self
    attr_accessor :acc
  end
end

describe Controller do
  let(:cntrl) { Controller.instance }

  def setup
    R.acc = ""
    G.init({}, [])
    G.script = Script.new <<~EOS
      watch("file")            { R.acc << "n" }
      watch("file", :added)    { R.acc << "a" }
      watch("file", :modified) { R.acc << "m" }
    EOS
  end

  def teardown
    cntrl.stop
  end

  it "fails with unknown what pattern" do
    cntrl.file_run("fail", nil)
    assert_equal "", R.acc
  end

  it "considers event_type nil" do
    check nil, "n"
  end

  it "considers event_type :added" do
    check :added, "an"
  end

  it "considers event_type :modified" do
    check :modified, "mn"
  end

  it "receives a matchdata" do
    G.script = Script.new "watch('ab(.)') { |m|
      R.acc << m[0]
      R.acc << m[1]
    }"

    cntrl.file_run("abc", nil)
    assert_equal "abcc", R.acc
  end

  private

  def check(type, expected)
    cntrl.file_run("file", type)
    assert_equal expected, R.acc
  end
end
