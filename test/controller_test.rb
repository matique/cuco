require "test_helper"
require "timeout"

describe Controller do
  let(:options) { {} }
  let(:cuco) { Controller.instance }
  let(:script) { Script.new }

  def teardown
    cuco.stop
  end

  it "stops" do
    cuco.stop
    assert_nil cuco.listener
  end

  it "initializes" do
    cuco.init(options, [])
  end

  it "runs" do
    cuco.init(options, [])
    assert_raises(Timeout::Error) do
      Timeout.timeout(0.1) { cuco.run }
    end

    assert cuco.listener
  end

  it "read .watchr" do
    filename = ".watchr"

    script.load_file filename
    assert_equal 2, script.__rules.size
  end

  private

  def test_files
    dir = File.join(Dir.pwd, "test", "files")
    files = find_files_in(dir)
    files.collect { |file| File.join(dir, file) }
  end

  def find_files_in(dir)
    entries = Dir.entries(dir)
    entries.reject { |entry| File.directory?(entry) }
  end
end
