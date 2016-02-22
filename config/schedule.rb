set :output, "/home/rails/shared/log/schedule.log"

job_type :rbenv_rake, %Q{export PATH=/opt/rbenv/shims:/opt/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && RAILS_ENV=production bundle exec rake :task --silent :output }
job_type :rbenv_runner, %Q{export PATH=/opt/rbenv/shims:/opt/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && RAILS_ENV=production bundle exec rails runner :task --silent :output }


every 1.day, at: '10:30 am' do
    rbenv_runner "EventRemindersJob.perform_later"
end

every 1.day, at: '9:00 am' do
    rbenv_runner "BillingNotificationsJob.perform_later"
end

# every 15.minutes do
#   rbenv_runner "EventMatchingJob.perform_later"
# end

every 1.week do
    rbenv_runner "ArchiveNotificationsJob.perform_later"
end

every 1.day, at: '5:00 am' do
    rbenv_runner 'ResetCounterCacheJob.perform_later'
end

every 1.hour do
    rbenv_runner "UpdateCoverPhotoJob.perform_later(users: nil)"
end
