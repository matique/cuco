class Script
  attr_reader :__rules

  def initialize
    reset
  end

  def load(str)
    reset
    instance_eval str
  end

  def load_file(filename)
    file_data = File.read(filename)
    load file_data
  end

  def watch(pattern, type = nil, &block)
    @__rules << Rule.new(pattern, type, block)
  end

  def match_run(rule, pattern)
    md = pattern.match(rule.pattern)
    rule.proc.call(md) if md
  end

  def run(pattern, type = nil)
    @__rules.select { |rule| match_run(rule, pattern) }
  end

  private

  def reset
    @__rules = []
  end
end

# $ sudo sh -c "echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf"
# $ sudo sysctl -p
