#!/usr/bin/env ruby

require 'rubygems'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'volunteer_a_tron'

location = ARGV[0] || 'london'

search_base = "http://github.com/search?type=Users&language=ruby&q=location:#{location}"

volunteer_a_tron = VolunteerATron.new

volunteer_a_tron.fetch_all_users(search_base)

puts volunteer_a_tron.users

