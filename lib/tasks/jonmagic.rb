namespace :jonmagic do
  desc "stuff I want to do"
  task(:rewind) do
    `cd #{RAILS_ROOT}`
    puts "rewinding"
    `rm db/development.sqlite3`
    puts "migrating database up\n"
    `rake db:migrate`
    puts "bootstrapping the db"
    `./script/runner db/bootstrap.rb`
  end
end