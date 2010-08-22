#!/usr/bin/env ruby

require 'rubygems'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'volunteer_a_tron'

who = ARGV[0] || 'maccman'

volunteer = VolunteerATron::Volunteer.new(who)

volunteer.fetch_all_repos

print "Do we thing #{volunteer.github_user_name} has done anything interesting?"
if volunteer.done_anything_interesting?
  puts ' Yes'
  puts "Interesting #{volunteer.what_might_be_interesting.size} vs. Uninteresting #{volunteer.repos.size}"
  puts volunteer.what_might_be_interesting
else
  puts ' No'
end

