module G
  class << self
    attr_reader :debug, :pwd, :scriptname

    def init(options = {}, argv = [])
      @options = options
      @debug = options[:debug]
      @pwd = File.realpath(Dir.pwd)
      @scriptname = File.expand_path(argv.first || ".watchr", pwd)

      log "Cuco starts at #{Time.now}"
      print_config if debug
    end

    def log(message)
      puts "*** #{message}" if debug
    end

    def print_config
      log "options #{@options.inspect}"
      log "pwd     <#{pwd}>"
      log "scriptname <#{scriptname}>"
    end
  end
end
