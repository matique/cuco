require "listen"
require "singleton"

class Controller
  include Singleton

  attr_reader :listener

  def run
    G.log "Controller.run"
    return if listener

    start_listener
    sleep
  rescue
    stop
    raise
  end

  def stop
    G.log "Controller.stop"
    listener&.stop
  ensure
    @listener = nil
  end

  private

  def start_listener
    @listener = Listen.to(G.pwd) do |modified, added, removed|
      process_events(modified, added, removed)
    end

    listener.start
    G.log "Listen started"
  end

  def process_events(modified, added, removed)
    G.log "Controller.process_events(#{modified})"

    events = build_events(modified, added, removed)
    reload_script(events)

    process_remaining_events(events)
  end

  def process_remaining_events(events)
    events.each do |type, files|
      run_files(files, type)
    end
  end

  def build_events(modified, added, removed)
    {
      modified: modified.dup,
      added: added.dup,
      removed: removed.dup
    }
  end

  def reload_script(events)
    events.each do |type, files|
      next unless files.delete(G.scriptname)

      reload_or_reset_script(type)
    end
  end

  def reload_or_reset_script(type)
    if type == :removed
      reset_script
    else
      load_script
    end
  end

  def reset_script
    warn "Watch script was removed: #{G.scriptname}"
    Script.reset
  end

  def load_script
    source = File.read(G.scriptname)
    Script.load(source, G.scriptname)
  rescue StandardError, SyntaxError => e
    warn "Cuco: #{e.class}: #{e.message}"
    G.log e.backtrace.first(5).join("\n")
  end

  def run_files(files, type)
    return if files.empty?

    G.log "Controller.run_files(#{files}, #{type})"

    base = Pathname.new(G.pwd)

    files.each do |filename|
      absolute = Pathname.new(filename).expand_path
      relative = absolute.relative_path_from(base).to_s
      run_file(relative, type)
    end
  end

  def run_file(filename, type = nil)
    G.log "run_file(#{filename}, #{type})"

    Script.dispatch(filename, type)
  end
end
