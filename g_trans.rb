#!/usr/bin/env ruby
# frozen_string_literal: true

# INSTALLATION:
#  brew install phantomjs
#  gem install poltergeist

require 'optparse'
require 'cgi'
require 'capybara/poltergeist'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: example.rb [options]'
  options[:locale] = 'en'

  opts.on('-j', '--japanese', 'to Japanese') do |_j|
    options[:locale] = 'ja'
  end
  opts.on('-k', '--korean', 'to Korean') do |_k|
    options[:locale] = 'ko'
  end
end.parse!

translate = CGI.escape(ARGV.join(' '))
exit if translate.empty?

session = Capybara::Session.new(:poltergeist)
session.visit(
  "https://translate.google.com/#auto/#{options[:locale]}/#{translate}"
)

puts session.first('span#result_box').text
