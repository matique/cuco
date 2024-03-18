require "test_helper"

describe Cuco do
  let(:cuco) { Controller.instance }

  it "usage" do
    out, _err = capture_io do
      puts `bin/cuco -h`
    end

    assert_match(/Usage/, out)
  end

  it "options" do
    options = {opt: 1234}
    cuco.init(options, [])

    assert_equal options, cuco.options
  end

  # it "coverage options debug" do
  #   out, _err = capture_io do
  #     puts `bin/cuco -d`
  #     # Timeout::timeout(0.1) { puts `bin/cuco -d` }
  #   end
  #
  #   assert_match(/:debug=>true/, out)
  #   assert_match(/script  <.watchr>/, out)
  #   assert_match(/pwd/, out)
  # end
end
