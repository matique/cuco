# Cuco

[![Gem Version](https://img.shields.io/gem/v/cuco?color=168AFE&logo=rubygems&logoColor=FE1616)](https://rubygems.org/gems/cuco)
[![Downloads](https://img.shields.io/gem/dt/cuco?color=168AFE&logo=rubygems&logoColor=FE1616)](https://rubygems.org/gems/cuco)
[![GitHub Build](https://img.shields.io/github/actions/workflow/status/matique/cuco/rake.yml?logo=github)](https://github.com/matique/cuco/actions/workflows/rake.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-168AFE.svg)](https://github.com/standardrb/standard)
[![MIT License](https://img.shields.io/badge/license-MIT-168AFE.svg)](http://choosealicense.com/licenses/mit/)

A simple file-watching utility written in Ruby.

*Cuco* watches a directory for filesystem changes and
executes callbacks when filenames match registered patterns.

Watch rules are defined in a user-supplied Ruby script
(usually called .watchr).
Intermixed "watch" commands specify what to do
for the particular modified files.

### Features

* Watch files using strings or regular expressions
* React to added, modified, and removed files
* Filter rules by event type
* Access regular-expression matches inside callbacks
* Reload the watch script automatically when it changes
* Preserve previously loaded rules when a script fails to load
* Execute multiple matching rules in registration order

*Cuco* is:

* Simple to use
* Highly flexible
* Evented               ( uses gem listen )
* Portable              ( Ruby )

## Installation

```ruby
$ gem install cuco
```

It requires:

- Ruby 3.2 or newer
- Bundler

## Usage

Create a _.watchr_ file in your project directory:

```ruby
# .watchr
puts "Hello World"
watch(".*\.rb$") do |match|
  # Callback
  puts "Ruby file changed: #{match[0]}"
end
```

Start Cuco:

```ruby
$ cuco
```

*Cuco* now monitors the current working directory
and executes the callback whenever a matching file
is added, modified, or removed.

## A simple example of a script file

This sample script is intended for testing purposes with Minitest.
*md* is the match-data (see Ruby regular expressions).

```ruby
watch( 'test/.*_test\.rb$' ) { |md| run_it(md[0]) }
watch( 'lib/(.*)\.rb$' )     { |md| run_it("test/#{md[1]}_test.rb") }

def run_it(file)
  system %(bundle exec ruby -I test #{file})
end

Signal.trap("QUIT") { system("bundle exec rake") } # Ctrl-\ or ctrl-4
Signal.trap("INT")  { abort("Interrupted\n") }     # Ctrl-C
```

## Script

Scripts are pure Ruby:

```ruby
puts "Hello World"

watch(".*\.rb$") do |match|
  # Callback
  puts "Ruby file changed: #{match[0]}"
end
```

Intermixed are _watch_ rules that match observed files to an action.
The matching is achieved by a _match specification_.
The action is specified by a block (see above sample).

Updates to the _script_ file are picked up
on the fly (no need to restart *cuco*),
so experimenting is painless.
If loading the new script fails,
the previously registered rules are preserved.

If the watch script is removed, its registered rules are cleared.

It's easy to see why *cuco* is so flexible,
since the whole command is custom.
The above actions could just as easily call "jruby", "ruby --rubygems",
"ruby -I lib", etc. or any combination of these.

See directory _scripts_ for more samples.

## Match Specification

The _watch_ method registers a rule consisting of a filename _pattern_
and an optional _event type_.

Rules are executed in registration order.

_Patterns_ can be strings (converted to regular expressions)
or regular expressions:

By default, a rule matches all three filesystem _event types_:

- :added
- :modified
- :removed

You can restrict a rule to a specific _event type_:

```ruby
watch('\.rb$', :modified) do |match|
  puts "Modified: #{match[0]}"
end
```

## Command-line options

```ruby
Options:
    -d, --debug    Debugging output
    -v, --version  Show version
    -h, --help     Show this message
```

## Miscellaneous

*Cuco* is heavily inspired by:

* gem watchr
* gem observr (a follow-up of gem watchr)

Copyright (c) 2024-2026 Dittmar Krall (www.matiq.com),
released under the [MIT license](https://opensource.org/licenses/MIT).
