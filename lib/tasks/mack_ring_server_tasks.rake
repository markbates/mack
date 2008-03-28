namespace :mack do
  namespace :ring_server do
    
    desc "Start the Rinda ring server"
    task :start do
      `mack_ring_server start`
    end
    
    desc "Stop the Rinda ring server"
    task :stop do
      `mack_ring_server stop`
    end
    
  end # ring_server
end # mack

alias_task "mack:ring_server:restart", "mack:ring_server:stop", "mack:ring_server:start"