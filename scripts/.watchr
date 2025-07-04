TESTING = %w[test]
HH = "#" * 22 unless defined?(HH)
H = "#" * 5 unless defined?(H)

def usage
  puts <<~EOS
    Ctrl-\\ or ctrl-4   Running all tests
    Ctrl-C             Exit
  EOS
end

def run(cmd)
  puts "#{HH} #{Time.now} #{HH}"
  puts "#{H} #{cmd}"
  system "/usr/bin/time --format '#{HH} Elapsed time %E' #{cmd}"
end

def run_it(type, files)
  files.split(" ").flatten.each do |file|
    case type
    # when "test" then run %(rails test #{file})
    when "test" then run %(spring rails test #{file})
    #  when 'spec';  run %(spring rspec -X #{file})
    else; puts "#{H} unknown type: #{type}, file: #{file}"
    end
  end
end

def run_all_tests
  puts "\n#{HH} Running all tests #{HH}\n"
  system "spring stop"
  TESTING.each { |dir| run "bundle exec rails #{dir}" if File.exist?(dir) }
end

def run_matching_files(base)
  base = base.split("_").first
  TESTING.each { |type|
    files = Dir["#{type}/**/*.rb"].select { |file| file =~ /#{base}_.*.rb/ }
    run_it type, files.join(" ") unless files.empty?
  }
end

TESTING.each { |type|
  watch("#{type}/#{type}_helper.rb$") { run_all_tests }
  watch("lib/.*.rb$") { run_all_tests }
  watch("#{type}/.*/*_#{type}.rb$") { |match| run_it type, match[0] }
  watch("#{type}/data/(.*).rb$") { |match|
    m1 = match[1]
    run_matching_files("#{type}/#{m1}/#{m1}_#{type}.rb")
  }
}

%w[rb erb haml slim].each { |type|
  watch("app/.*/(.*).#{type}$") { |match|
    run_matching_files(match[1])
  }
}

Signal.trap("QUIT") { run_all_tests }          # Ctrl-\ or ctrl-4
Signal.trap("INT") { abort("Interrupted\n") }  # Ctrl-C
usage
