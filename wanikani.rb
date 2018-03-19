#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/https'
require 'uri'
require 'json'

res = Net::HTTP.get(
  URI('https://www.wanikani.com/api/user/' \
      'dd710984a1884d41d57a140ddc3adb3a' + # REPLACE WITH YOUR API KEY
      '/study-queue')
)

avaiable = JSON.parse(res)['requested_information']

if avaiable['lessons_available'].to_i.positive? ||
   avaiable['reviews_available'].to_i.positive?
  `osascript -e 'display notification
    "WaniKani is ready for you!" with title "Reminder"'`
end
