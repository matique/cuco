if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
  end
end

require "minitest/autorun"
require "ricecream"

require "cuco/controller"
require "cuco/cuco"
require "cuco/script"
require "timeout"
