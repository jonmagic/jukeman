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
    require 'lib/dcop'
    username = Dir.pwd.split('/')[2]
    hostname = `cat /etc/hostname`.gsub(/\n|\r/, '')
    DCOP.build!('amarok', 'user' => username, 'session' => '.DCOPserver_'+hostname+'__0')
    if Journal.import_from_server || Amarok::Player.isPlaying == "false\n" then Playlist.active.apply_to_amarok end
  end
end