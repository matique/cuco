require "listen"
require "singleton"
require "cuco"
require "script"

class Controller
  include Singleton

  attr_reader :listener
  attr_reader :options
  attr_reader :pwd_size
  attr_reader :script_name
  attr_reader :script

  def init(options, argv)
    @options = options
    @script_name = argv.first || ".watchr"
    @pwd_size = Dir.pwd.size

    if @options[:debug]
      puts "options #{@options}"
      puts "pwd     <#{@pwd}>"
      puts "script_name <#{@script_name}>"
    end
  end

  def run
    stop
    @script = Script.new
    @script.load_file(@script_name)
    @listener = Listen.to(".") do |modified, added, removed|
      run_files(modified, :modified)
      run_files(added, :added)
    end

    @listener.start
    sleep
  end

  def stop
    @listener&.stop
    @script = nil
    @listener = nil
  end

  private

  def run_files(files, type)
    files.map! { |filename| filename[@pwd_size + 1 .. -1] }
    files.each { |filename| @script.run(filename, type) }
  end
end
