#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/https'
require 'json'

# replace with API_KEY with your own
# can be found here when logged in: https://www.wanikani.com/settings/account#public-api-key
API_KEY = 'dd710984a1884d41d57a140ddc3adb3a'
ALERT = 'WaniKani is ready for you!'

res = Net::HTTP.get(
  URI("https://www.wanikani.com/api/user/#{API_KEY}/study-queue")
)

avaiable = JSON.parse(res)['requested_information']

if avaiable['lessons_available'].to_i.positive? ||
   avaiable['reviews_available'].to_i.positive?
  `osascript -e 'display notification "#{ALERT}" with title "Reminder"'`
end
