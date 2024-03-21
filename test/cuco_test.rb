require "test_helper"

describe Cuco do
  def setup
    G.init({}, [])
  end

  it "usage" do
    out, _err = capture_io do
      puts `bin/cuco -h`
    end

    assert_match(/Usage/, out)
  end

  it "coverage G.print " do
    out, err = capture_io do
      G.print
    end

    assert out
    assert_equal "", err
    assert_match(/scriptname/, out)
    assert_match(/.watchr/, out)
    assert_match(/pwd/, out)
  end

  it "options" do
    options = {opt: 1234}
    G.init options, []

    assert_equal options, G.options
  end
end
