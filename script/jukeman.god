RAILS_ROOT = "/home/jukeman/apps/jukeman"

God.watch do |w|
  w.name = "jukeman"
  w.interval = 30.seconds # default      
  w.start = "mongrel_rails start -c #{RAILS_ROOT} -p 3333 \
    -P #{RAILS_ROOT}/log/mongrel.3333.pid  -d"
  w.stop = "mongrel_rails stop -P #{RAILS_ROOT}/log/mongrel.3333.pid"
  w.restart = "mongrel_rails restart -P #{RAILS_ROOT}/log/mongrel.3333.pid"
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = File.join(RAILS_ROOT, "log/mongrel.3333.pid")

  w.uid = 'jukeman'
  w.gid = 'jukeman'
  
  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end
  
  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 300.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
    end
  
    restart.condition(:cpu_usage) do |c|
      c.above = 50.percent
      c.times = 5
    end
  end
  
  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end