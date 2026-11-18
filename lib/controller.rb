require "listen"
require "singleton"

class Controller
  include Singleton

  attr_reader :listener

  def run
    puts "*** Controller.run" if debug

    return if listener

    @listener = Listen.to(G.pwd) do |modified, added, removed|
      process_events(modified, added, removed)
    end

    listener.start
    puts "*** Listen started" if debug

    sleep
  rescue
    listener&.stop
    @listener = nil
    raise
  end

  def stop
    puts "*** Controller.stop" if debug

    listener&.stop
  ensure
    @listener = nil
  end

  private

  def process_events(modified, added, removed)
    puts "*** Controller.process_events(#{modified})" if debug
    events = {
      modified: modified.dup,
      added: added.dup,
      removed: removed.dup
    }

    reload_script(events)

    events.each do |type, files|
      run_files(files, type)
    end
  end

  def reload_script(events)
    events.each do |type, files|
      next unless files.delete(G.scriptname)

      if type == :removed
        warn "Watch script was removed: #{G.scriptname}"
        Script.reset
      else
        begin
          Script.load(File.read(G.scriptname), G.scriptname)
        rescue StandardError, SyntaxError => e
          warn "Cuco: #{e.class}: #{e.message}"
          warn e.backtrace.first(5).join("\n") if debug
        end
      end

      files.delete(G.scriptname)
    end
  end

  def run_files(files, type)
    return if files.empty?

    puts "*** Controller.run_files(#{files}, #{type})" if debug

    base = Pathname.new(G.pwd)

    files.each do |filename|
      absolute = Pathname.new(filename).expand_path
      relative = absolute.relative_path_from(base).to_s
      run_file(relative, type)
    end
  end

  def run_file(filename, type = nil)
    puts "*** run_file(#{filename}, #{type})" if debug

    Script.dispatch(filename, type)
  end

  def debug = G.debug
end
