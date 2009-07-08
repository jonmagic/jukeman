namespace :jukeman do
  desc "delete the db and refresh"
  task(:rewind) do
    `cd #{RAILS_ROOT}`
    `rm db/development.sqlite3`
    `rm -rf public/system/songs`
    `rake db:migrate`
  end
  
end