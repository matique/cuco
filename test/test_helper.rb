if ENV["COVERAGE"]
  require "simplecov"

  SimpleCov.start do
    add_filter "/test/"
  end
end

require "timeout"
require "minitest/autorun"
require "ricecream"

lib = File.expand_path("../lib/", __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require "controller"
require "global"
require "script"

module R
  class << self
    attr_accessor :result
  end
end
