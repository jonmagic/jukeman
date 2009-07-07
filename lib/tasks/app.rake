namespace :jukeman do
  desc "delete the db and refresh"
  task(:rewind) do
    `cd #{RAILS_ROOT}`
    `rm db/development.sqlite3`
    `rm -rf public/system/songs`
    `rake db:migrate`
  end
  
  desc "download updates from server and update amarok"
  task(:update_amarok) do
    `/home/jukeman/apps/jukeman/script/runner /home/jukeman/apps/jukeman/script/update-amarok`
  end
end