require "test_helper"

describe "Coverage" do
  let(:cntrl) { Controller.instance }

  def setup
    G.init({}, [])
  end

  it "coverage run files" do
    names = []
    cntrl.run_files(names, nil)
  end

  it "coverage run files script" do
    names = [G.scriptname]
    cntrl.run_files(names, nil)
  end
end
