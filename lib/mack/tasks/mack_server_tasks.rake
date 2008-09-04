namespace :mack do
  
  namespace :server do

    desc "Starts the webserver."
    task :start do |t|
      puts %{
This task has been removed. Please use the 'mackery' command to start/stop the server:

  $ mackery server

The environment can be set like this:

  $ mackery server -e test
  
  $ mackery server -p 8080 -e production # etc...
      }
    end # start

  end # server
  
end # mack

alias_task :server, "log:clear", "mack:server:start"