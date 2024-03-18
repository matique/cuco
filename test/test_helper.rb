if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
  end
end

require "minitest/autorun"
require "ricecream"
require "cuco"
require "controller"
require "script"
