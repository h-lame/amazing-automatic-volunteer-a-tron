#!/usr/bin/env ruby

require 'rubygems'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'volunteer_a_tron'

who = ARGV[0] || 'maccman'

volunteer = VolunteerATron::Volunteer.new(who)

volunteer.fetch_all_repos

puts volunteer.repos

