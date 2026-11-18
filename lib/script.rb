module Script
  VALID_EVENTS = %i[added modified removed].freeze

  class << self
    Rule = Data.define(:pattern, :event_type, :callback)

    attr_reader :rules

    def reset = @rules = []
    def debug = G.debug

    def load(source, filename = "(cuco)")
      previous = rules
      reset

      instance_eval(source, filename, 1)
    rescue StandardError, SyntaxError
      @rules = previous
      raise
    end

    def dispatch(filename, event_type = nil)
      puts "*** Script.run(#{filename}, #{event_type})" if debug
      rules.dup.each do |rule|
        next if rule.event_type && rule.event_type != event_type

        match = rule.pattern.match(filename)
        rule.callback.call(match) if match
      end
    end

    @rules = []

    private

    def watch(pattern, type = nil, &callback)
      raise ArgumentError, "watch requires a block" unless callback

      unless type.nil? || VALID_EVENTS.include?(type)
        raise ArgumentError, "invalid event type: #{type.inspect}"
      end

      unless pattern.is_a?(String) || pattern.is_a?(Regexp)
        raise ArgumentError, "pattern must be a String or Regexp"
      end

      regexp = pattern.is_a?(Regexp) ? pattern : Regexp.new(pattern)
      rules << Rule.new(regexp, type, callback)
    end
  end
end
