# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/Users/apprentice/Desktop/craigslist_scraper/test.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, :at => '9:15 am' do
#  command "/usr/bin/env ruby /Users/apprentice/svn/thewall/script/runner /Users/kip/svn/thewall/app/delete_old_posts.rb"
  command "ruby ~/Desktop/craigslist_scraper/lib/cron.rb"
end