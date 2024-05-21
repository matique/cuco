class Script
  attr_reader :__rules

  def initialize(str)
    @__rules = []
    instance_eval str
  end

  def watch(pattern, type = nil, &block)
    @__rules << Rule.new(pattern, type, block)
  end
end

# $ sudo sh -c "echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf"
# $ sudo sysctl -p
