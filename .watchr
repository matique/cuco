watch('test/.*_test\.rb$') { |md| run_it(md[0]) }
watch('lib/(.*)\.rb$') { |md| run_it("test/#{md[1]}_test.rb") }

def run_it(file)
  puts "***** ruby -I test #{file}"
  system %(bundle exec ruby -I test #{file})
end

def usage
  puts <<~EOS
    Ctrl-\\ or ctrl-4   Running all tests
    Ctrl-C             Exit
  EOS
end

Signal.trap("QUIT") { system("bundle exec rake") } # Ctrl-\ or ctrl-4
Signal.trap("INT") { abort("Interrupted\n") }     # Ctrl-C
usage
