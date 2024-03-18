require "test_helper"
require "script"

describe Script do
  let(:script) { Script.new }

  it "checks script instance" do
    assert script.instance_of?(Script)
    assert script.respond_to?(:__rules)
  end

  it "has no watcher" do
    script.load "n = 123"
    assert_equal 0, script.__rules.size
  end

  it "has one watcher" do
    script.load "n = 456; watch('.rb') { }"

    assert_equal 1, script.__rules.size
  end

  it "calls a watcher" do
    pattern = '\.rb'
    value = 123
    # script.load "n = value; watch(pattern) { n }" # WHAT??
    script.load "n = #{value}; watch('#{pattern}') { n }"

    rule = script.__rules.last
    assert_equal [pattern, value], [rule.pattern, rule.proc.call]
  end

  it "receives a matchdata" do
    script.load "watch('ab(.)') { |m| [m[0], m[1]] }"

    rule = script.__rules.last
    assert_equal ["abc", "c"], script.match_run(rule, "abc")
  end

  it "run" do
    pattern = '.*\.rb'
    script.load "watch('#{pattern}') { raise IOError }"

    assert_raises(IOError) { script.run "a.rb" }
  end

  it "does not run" do
    pattern = '.*\.rb'
    script.load "watch('#{pattern}') { raise IOError }"

    script.run "a.no" # no exception
  end
end
