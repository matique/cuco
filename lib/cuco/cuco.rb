Rule = Struct.new(:pattern, :event_type, :proc)

class G
  class << self
    attr_accessor :options
    attr_accessor :pwd
    attr_accessor :pwd_length
    attr_accessor :script
    attr_accessor :scriptname

    def init(options, argv)
      @options = options
      @scriptname = File.expand_path(argv.first || ".watchr")
      @pwd = Dir.pwd
      @pwd_length = @pwd.length

      puts "*** Cuco starts at #{Time.now}" if @options[:debug]
      print if @options[:debug]
    end

    def print
      puts "*** options #{@options}"
      puts "*** pwd     <#{@pwd}>"
      puts "*** pwd_length <#{@pwd_length}>"
      puts "*** scriptname <#{@scriptname}>"
      puts "*** script  <#{@script}>"
    end
  end
end
