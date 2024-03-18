require "test_helper"

describe Script do
  it "checks script" do
    script = Script.new ""
    assert script.instance_of?(Script)
    assert_equal %i[watch __rules].sort, script.public_methods(false).sort
  end

  it "has no watcher" do
    script = Script.new "n = 123"
    assert_equal 0, script.__rules.size
  end

  it "has one watcher" do
    script = Script.new "n = 456; watch('.rb') { }"

    assert_equal 1, script.__rules.size
  end

  it "calls a watcher" do
    pattern = '\.rb'
    value = 123
    script = Script.new "n = #{value}; watch('#{pattern}') { n }"

    rule = script.__rules.last
    assert_equal [pattern, value], [rule.pattern, rule.proc.call]
  end
end
