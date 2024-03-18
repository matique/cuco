require "listen"
require "singleton"
require "cuco"
require "script"

class Controller
  include Singleton

  attr_reader :listener

  def run
    puts "*** Controller.run" if debug
    @listener = Listen.to(".") do |modified, added, removed|
      run_files(modified, :modified)
      run_files(added, :added)
    end

    @listener.start
    puts "*** Listen started" if debug
    sleep
  end

  def stop
    puts "*** Controller.stop" if debug
    @listener&.stop
    G.script = nil
    @listener = nil
  end

  def run_files(files, type)
    puts "*** Controller.run_files(#{files}, #{type})" if debug
    if files.include?(G.scriptname)
      G.script = Script.new File.read(G.scriptname)
      return
    end

    files.map! { |filename| filename[G.pwd_length + 1..] }
    files.each { |filename| file_run(filename, type) }
  end

  def file_run(pattern, type = nil)
    puts "*** file_run(#{pattern}, #{type})" if debug
    G.script.__rules.select { |rule| match_run(rule, pattern) }
  end

  def match_run(rule, pattern)
    md = pattern.match(rule.pattern)
    puts "*** match_run #{rule}" if debug
    rule.proc.call(md) if md
  end

  def debug
    G.options[:debug]
  end
end
