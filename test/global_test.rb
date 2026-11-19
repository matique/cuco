require "test_helper"

describe G, "Global" do
  def setup
    G.init
  end

  it "prints configuration when enabled" do
    out, err = capture_io do
      G.init({debug: true})
#      G.print_config
    end

    assert_empty err
    assert_match(/Cuco starts/, out)
    assert_match(/options/, out)
    assert_match(/scriptname/, out)
    assert_match(/\.watchr/, out)
    assert_match(/pwd/, out)
  end

  it "initializes with default arguments" do
    assert_equal File.realpath(Dir.pwd), G.pwd
    assert_equal File.join(G.pwd, ".watchr"), G.scriptname
    refute G.debug
  end

  it "accepts a custom script filename" do
    G.init({}, ["custom.watchr"])

    assert_equal File.join(G.pwd, "custom.watchr"), G.scriptname
  end

  it "does not print debug information by default" do
    out, = capture_io do
      G.init
    end

    assert_empty out
  end

  it "accepts an absolute script filename" do
    filename = File.join(G.pwd, "custom.watchr")

    G.init({}, [filename])

    assert_equal filename, G.scriptname
  end
end
