# Cuco

[![Gem Version](https://badge.fury.io/rb/cuco.png)](http://badge.fury.io/rb/cuco)
[![GEM Downloads](https://img.shields.io/gem/dt/cuco?color=168AFE&logo=ruby&logoColor=FE1616)](https://rubygems.org/gems/cuco)

*Cuco* watch files in a directory and take an action when they change.

*Cuco* is controlled by a user-supplied script file.
Intermixed "watch" commands specify what to do
for the particular modified files.

*Cuco* is:

* Simple to use
* Highly flexible
* Evented               ( uses gem listen )
* Portable              ( Ruby )

Most importantly it is **agnostic** to:

* Test frameworks
* Web frameworks

## Installation

```ruby
$ gem install cuco
```

## Usage

```ruby
$ cuco          # default script file is .watchr
 Or
$ cuco path/to/script/file
```

will monitor files in the current directory tree
and react to events on those files in accordance with the script.

## A simple example of a script file (using Minitest):

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

Scripts are pure Ruby.

Intermixed are "watch" rules that match observed files to an action.
The matching is achieved by a pattern (a regular expression) parameter.
The action is specified by a block (see above sample).
*md* is the match-data.

Updates to script files are picked up on the fly (no need to restart *cuco*)
so experimenting is painless.

It's easy to see why *cuco* is so flexible,
since the whole command is custom.
The above actions could just as easily call "jruby", "ruby --rubygems",
"ruby -I lib", etc. or any combination of these.

## Miscellaneous

*Cuco* is heavily inspired by:

* gem watchr
* gem observr (a follow-up of gem watchr)

Copyright (c) 2024 Dittmar Krall (www.matiq.com),
released under the [MIT license](https://opensource.org/licenses/MIT).
