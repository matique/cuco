require "test_helper"

describe "App" do
  it "displays usage" do
    out = `bin/cuco -h`

    assert_match(/Usage/, out)
    assert $?.success?
  end
end
