#!/usr/bin/env ruby

require 'rubygems'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'volunteer_a_tron'

location = ARGV[0] || 'london'

search_base = "http://github.com/search?type=Users&language=ruby&q=location:#{location}"

volunteer_a_tron = VolunteerATron.new

volunteer_a_tron.fetch_all_users(search_base)

puts volunteer_a_tron.users

all_interesting_repos = volunteer_a_tron.users.inject([]) do |interesting_repos, volunteer|
  volunteer.fetch_all_repos
  print "Do we think #{volunteer.github_user_name} has done anything interesting?"
  if volunteer.done_anything_interesting?
    puts ' Yes'
    interesting_repos += volunteer.what_might_be_interesting
  else
    puts ' No'
  end
  interesting_repos
end

print "Do we think there are any interesting repos? "
if all_interesting_repos.size > 0
  puts "Yes"
  puts "You might want to check out these: "
  puts all_interesting_repos.sort
else
  puts "No"
end
