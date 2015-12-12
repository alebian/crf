# CRF - Check Repeated Files
[![Gem Version](https://badge.fury.io/rb/crf.svg)](https://badge.fury.io/rb/crf)
[![Dependency Status](https://gemnasium.com/alebian/crf-ruby.svg)](https://gemnasium.com/alebian/crf-ruby)
[![Build Status](https://travis-ci.org/alebian/crf-ruby.svg)](https://travis-ci.org/alebian/crf-ruby)
[![Code Climate](https://codeclimate.com/github/alebian/crf-ruby/badges/gpa.svg)](https://codeclimate.com/github/alebian/crf-ruby)
[![Test Coverage](https://codeclimate.com/github/alebian/crf-ruby/badges/coverage.svg)](https://codeclimate.com/github/alebian/crf-ruby/coverage)
[![Inline docs](http://inch-ci.org/github/alebian/crf-ruby.svg)](http://inch-ci.org/github/alebian/crf-ruby)

This gem finds exact duplicate files inside a given directory and all sub directories. The result of the execution gets stored in a file called crf_log.txt. The execution time depends on the amount of files and each size, so be careful (or patient). You have options to run an approximated version of the algorithm which is faster but more inaccurate.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crf

## Usage

After installing the gem, you can use it in your command line:

```
crf PATH [-i] [-p] [-f] [-n] [-o]
```
Or you can use it in any ruby code you want:

```ruby
require 'crf'

path = './test'
options = { interactive: true, progress: true, fast: false }

crf_checker = Crf::Checker.new(path, options)
crf_checker.check_repeated_files
```

The -i, --interactive option lets you control the deletion of the files. In the command line you will be asked for every repetition if you want to delete it or not (this is the default).

The -p, --progress option shows a progress while looking for duplicates (this is the default).

The -f, --fast option only checks if the files have the same size (is faster but it does not mean that the files are duplicates).

The -n, --no-interactive option will save the first file of the repetitions and remove the rest of the duplicates without asking.

The -o, --no-progress option will make CRF run without showing the progress bar.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`rubocop -R --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request
