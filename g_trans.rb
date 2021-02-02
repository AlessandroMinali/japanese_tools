#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'cgi'
require 'capybara/apparition'

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

retries = 3

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, browser_logger: nil)
end

begin
  session = Capybara::Session.new(:apparition)
  session.visit("https://translate.google.com/?sl=auto&tl=#{options[:locale]}&text=#{translate}")
  sleep(0.5)
  # prone to break in the future ...
  text = session.find_all('span[jsname][jsaction]:not([class]):not([jscontroller])')[1].text

  puts text
rescue StandardError
  unless retries.zero?
    retries -= 1
    puts 'Retrying...'
    retry
  end
end
