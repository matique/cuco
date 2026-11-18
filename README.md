# Cuco

[![Gem Version](https://img.shields.io/gem/v/cuco?color=168AFE&logo=rubygems&logoColor=FE1616)](https://rubygems.org/gems/cuco)
[![Downloads](https://img.shields.io/gem/dt/cuco?color=168AFE&logo=rubygems&logoColor=FE1616)](https://rubygems.org/gems/cuco)
[![GitHub Build](https://img.shields.io/github/actions/workflow/status/matique/cuco/rake.yml?logo=github)](https://github.com/matique/cuco/actions/workflows/rake.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-168AFE.svg)](https://github.com/standardrb/standard)
[![MIT License](https://img.shields.io/badge/license-MIT-168AFE.svg)](http://choosealicense.com/licenses/mit/)

*Cuco* is a simple and flexible file-watching utility written in Ruby.

It monitors a directory for filesystem changes and
executes Ruby callbacks whenever filenames match registered patterns.

Watch rules are defined in a Ruby script, usually named .watchr.

```ruby
watch('\.rb$') do |match|
  puts "Ruby file changed: #{match[0]}"
end
```
That's all it takes to get started.

### Features

* Watch files using strings or regular expressions
* React to added, modified, and removed files
* Filter rules by event type
* Access regular-expression matches inside callbacks
* Register multiple rules and execute them in order
* Reload the watch script automatically when it changes
* Preserve previously loaded rules when a script fails to load
* Execute arbitrary Ruby code in callbacks.

*Cuco* is:

| :---        |    :----   |
| Simple       | a small and straightforward API |
| Flexible     | watch rules are ordinary Ruby code |
| Event-driven | powered by the listen gem |
| Portable     | runs wherever Ruby runs |

&nbsp; | &nbsp;
------ | -----
Stuff  | More things




## Requirements

- Ruby 3.2 or newer

## Installation

Install *Cuco* using RubyGems:

```ruby
$ gem install cuco
```

This automatically installs its runtime dependencies.

## Quick Start

Create a _.watchr_ file in your project directory:

```ruby
# .watchr

watch(".*\.rb$") do |match|
  # Callback
  puts "Ruby file changed: #{match[0]}"
end
```

Start Cuco:

```ruby
$ cuco
```

*Cuco* now monitors the current working directory.

Whenever a matching file is added, modified, or removed,
the callback is executed.

You can also specify a different watch script:

```ruby
$ cuco scripts/.watchr-rails
```

## Watch Scripts

Watch scripts are ordinary Ruby files.

They can contain arbitrary Ruby code, including method definitions,
constants, and watch declarations.

The watch method registers a rule consisting of:

- A filename pattern
- An optional filesystem event type
- A callback block

### Basic rules

A pattern can be either a String or a Regexp.

String patterns are automatically converted into regular expressions.
```ruby
watch('\.rb$') do |match|
  puts "Ruby file changed: #{match[0]}"
end

watch(/\.erb$/) do |match|
  puts "ERB file changed: #{match[0]}"
end
```

Patterns are matched against filenames relative to the watched directory.

Remember that patterns are regular expressions, not shell globs.

### Event types

By default, a rule responds to all three filesystem event types:

| Event     | Description         |
|-----------|---------------------|
| :added    | A file was added    |
| :modified | A file was modified |
| :removed  | A file was removed  |

You can restrict a rule to a particular event type:
```ruby
watch('\.rb$', :added) do |match|
  puts "New Ruby file: #{match[0]}"
end

watch('\.rb$', :modified) do |match|
  puts "Modified Ruby file: #{match[0]}"
end

watch('\.rb$', :removed) do |match|
  puts "Removed Ruby file: #{match[0]}"
end
```

A rule without an explicit event type responds to all three events.

### Match data

Callbacks receive a Ruby MatchData object.

This provides access to the complete matching filename
and any captured groups.

For example:
```ruby
watch('lib/(.+)\.rb$') do |match|
  puts "File: #{match[0]}"
  puts "Name: #{match[1]}"
end
```

For a file named lib/controller.rb, the callback receives:

| match[0] | lib/controller.rb |
| match[1] | controller        |

### Rule execution order

Rules are executed in their registration order.

Multiple rules can match the same filename:
```ruby

watch('\.rb$') do |match|
  puts "Ruby file detected: #{match[0]}"
end

watch('_test\.rb$') do |match|
  puts "Test file detected: #{match[0]}"
end
```

Both callbacks execute when a matching test file changes.

## Practical Examples

### Run tests when Ruby files change

```ruby
watch('test/.*_test\.rb$') do |match|
  system("bundle exec ruby -I test #{match[0]}")
end

watch('lib/(.+)\.rb$') do |match|
  test_file = "test/#{match[1]}_test.rb"

  system("bundle exec ruby -I test #{test_file}") if File.file?(test_file)
end
```

### Run the complete test suite

```ruby
watch('\.rb$', :modified) do
  system("bundle exec rake test")
end
```

### Watch multiple file types

```ruby
watch('\.(css|scss)$') do |match|
  puts "Stylesheet changed: #{match[0]}"
end

watch('\.(js|ts)$') do |match|
  puts "JavaScript changed: #{match[0]}"
end

watch('\.(html|erb)$') do |match|
  puts "Template changed: #{match[0]}"
end
```

### Use helper methods

Since watch scripts are ordinary Ruby,
you can organize your code however you like.

```ruby
def run_tests(file)
  system("bundle exec ruby -I test #{file}")
end

watch('test/.*_test\.rb$') do |match|
  run_tests(match[0])
end

watch('lib/(.+)\.rb$') do |match|
  run_tests("test/#{match[1]}_test.rb")
end
```

## Automatic Script Reloading

*Cuco* monitors its own watch script.

Whenever the script changes, *Cuco* automatically reloads it.
There is no need to restart the process.

This makes experimenting with watch rules particularly convenient.

*Cuco* also handles unsuccessful reloads gracefully:

- Successful reload: The previous rules are replaced with the new rules
- Failed reload: The previous rules remain active
- Script removed: All registered rules are cleared.

The last successfully loaded rules therefore remain available
even if an edited script contains a syntax or runtime error.

## Command-line options

```ruby
Options:
    -d, --debug    Debugging output
    -v, --version  Show version
    -h, --help     Show this message
```

### Examples:

Start Cuco using the default .watchr script:
```ruby
$ cuco
```

Specify a custom script:
```ruby
$ cuco scripts/development.watchr
```

Enable debugging output:
```ruby
$ cuco --debug
```

Display the installed version:
```ruby
$ cuco --version
```

## .Inspiration

*Cuco* is heavily inspired by:

* watchr
* observr

## License

Copyright (c) 2024-2026 Dittmar Krall (www.matiq.com).

Released under the [MIT license](https://opensource.org/licenses/MIT).
