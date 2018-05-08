#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/https'
require 'cgi'
require 'json'

translate = CGI.escape(ARGV.join(' '))
exit if translate.empty?

uri = URI("https://jisho.org/api/v1/search/words?keyword=#{translate}")
res = Net::HTTP.get(uri)

entry = JSON.parse(res)['data'][0]

exit if entry.nil?

jp = entry['japanese'][0]
en = entry['senses']

puts jp['word'] if jp['word']
puts jp['reading'] if jp['reading']
puts if jp['reading'] || jp['word']

en.each_with_index do |i, index|
  puts "#{index + 1}. #{i['english_definitions'].join('; ')}"
end
