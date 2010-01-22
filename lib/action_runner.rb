puts '*** Starting ***'
trap('TERM') { Rails.logger.info '*** Exiting ***'; $exit = true }
trap('INT')  { Rails.logger.info '*** Exiting ***'; $exit = true }

loop do
  Action.fetch_and_run_actions

  if $exit
    Rails.logger.info '*** Cleaning up ***'
    break
  end
  sleep 5
end