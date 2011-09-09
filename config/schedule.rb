# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
 if ENV['RAILS_ENV'] == 'development'
 set :output, "/home/startup/APPS/tiipsy/cron_log.log"
 end
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
set :environment, :ENV['RAILS_ENV']
every 2.minutes do 
   runner "Servicelisting.checkexpirations"
end

every 1.minutes do 
   logger.debug "hi"
end


# Learn more: http://github.com/javan/whenever
