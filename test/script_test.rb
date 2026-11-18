require "test_helper"

describe Script do
  def setup
    Script.reset
  end

  it "resets rules" do
    Script.reset

    assert_empty Script.rules
  end

  it "clears rules when loading an empty script" do
    Script.load ""

    assert_empty Script.rules
  end

  it "requires a block" do
    assert_raises(ArgumentError) do
      Script.load "watch('.rb')"
    end
  end

  it "rejects invalid events" do
    assert_raises(ArgumentError) do
      Script.load "watch('.rb', :unknown) { }"
    end
  end

  it "rejects invalid regular expressions" do
    assert_raises(RegexpError) do
      Script.load "watch('[') { }"
    end
  end

  it "has no watcher" do
    Script.load "n = 123"

    assert_empty Script.rules
  end

  it "accepts a Regexp" do
    pattern = /foo\.rb/

    Script.load "watch(#{pattern.inspect}) { }"

    assert_equal pattern, Script.rules.first.pattern
  end

  it "rejects invalid pattern types" do
    assert_raises(ArgumentError) do
      Script.load "watch(123) { }"
    end
  end

  it "replaces rules when loading a new script" do
    Script.load "watch('second') { }"

    assert_equal 1, Script.rules.size
    assert_equal(/second/, Script.rules.first.pattern)
  end

  it "preserves existing rules when regexp compilation fails" do
    Script.load "watch('old') { }"

    assert_raises(RegexpError) do
      Script.load "watch('[') { }"
    end

    assert_equal 1, Script.rules.size
    assert_equal(/old/, Script.rules.first.pattern)
  end

  it "preserves existing rules when script evaluation fails" do
    Script.load "watch('old') { }"

    assert_raises(RuntimeError) do
      Script.load <<~RUBY
        watch('new') { }
        raise "something went wrong"
      RUBY
    end

    assert_equal 1, Script.rules.size
    assert_equal(/old/, Script.rules.first.pattern)
  end

  it "registers multiple rules in order and accepts valid event types" do
    Script.load <<~RUBY
      watch('first', :added) { }
      watch('second', :modified) { }
      watch('third', :removed) { }
    RUBY

    assert_equal %w[first second third],
      Script.rules.map { |rule| rule.pattern.source }

    assert_equal %i[added modified removed], Script.rules.map(&:event_type)
  end

  it "preserves existing rules when syntax errors occur" do
    Script.load "watch('old') { }"

    assert_raises(SyntaxError) do
      Script.load "watch('new') {"
    end

    assert_equal 1, Script.rules.size
    assert_equal(/old/, Script.rules.first.pattern)
  end
end
