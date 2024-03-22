if ENV["COVERAGE"]
  require "simplecov"

  SimpleCov.start do
    add_filter "/test/"
  end
end

require "minitest/autorun"
require "ricecream"

require "controller"
require "cuco"
require "script"
require "timeout"
