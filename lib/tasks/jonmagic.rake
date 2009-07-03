namespace :app do
  desc "stuff I want to do"
  task(:rewind) do
    `cd #{RAILS_ROOT}`
    `rm db/development.sqlite3`
    `rm -rf public/system/songs`
    `rake db:migrate`
  end
end