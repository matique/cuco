module G
  class << self
    attr_reader :debug, :pwd, :scriptname

    def init(options = {}, argv = [])
      @options = options
      @debug = options[:debug]
      @pwd = File.realpath(Dir.pwd)
      @scriptname = File.expand_path(argv.first || ".watchr", pwd)

      puts "*** Cuco starts at #{Time.now}" if debug
      print_config if debug
    end

    def print_config
      puts "*** options #{@options.inspect}"
      puts "*** pwd     <#{pwd}>"
      puts "*** scriptname <#{scriptname}>"
    end
  end
end
