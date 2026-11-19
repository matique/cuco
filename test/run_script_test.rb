require "test_helper"

#class R
#  class << self
#    attr_accessor :acc
#  end
#end

describe Script, "run" do
  def setup
    R.result = []
    Script.reset
  end

  it "executes rules in registration order" do
    Script.load <<~RUBY
      watch('.rb') { R.result << 1 }
      watch('.rb') { R.result << 2 }
    RUBY
    Script.dispatch("test.rb")

    assert_equal [1, 2], R.result
  end

  it "provides capture groups to callbacks" do
    Script.load "watch('(.+)\\.rb') { |match| R.result << match[1] }"

    Script.dispatch("test.rb")

    assert_equal ["test"], R.result
  end

  it "does not execute rules for another event type" do
    Script.load <<~RUBY
      watch('.rb', :added) { R.result << :added }
    RUBY

    Script.dispatch("test.rb", :removed)

    assert_empty R.result
  end

  it "executes rules without an event type for every event" do
    Script.load <<~RUBY
      watch('.rb') { R.result << :all }
    RUBY

    Script.dispatch("test.rb", :added)
    Script.dispatch("test.rb", :removed)

    assert_equal [:all, :all], R.result
  end

  it "filters rules by event type" do
    Script.load <<~RUBY
      watch('.rb', :added) { R.result << :added }
      watch('.rb', :removed) { R.result << :removed }
    RUBY

    Script.dispatch("test.rb", :added)

    assert_equal [:added], R.result
  end

  it "does not execute callbacks for non-matching patterns" do
    Script.load <<~RUBY
      watch('.rb') { R.result << :matched }
    RUBY

    Script.dispatch("test.txt")

    assert_empty R.result
  end
end
