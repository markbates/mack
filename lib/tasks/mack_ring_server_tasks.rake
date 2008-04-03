require 'rinda/ring'
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
    
    namespace :services do
      
      desc "Lists all services on the ring server"
      task :list do
        DRb.start_service
        ring_server = Rinda::RingFinger.primary
        services = ring_server.read_all([nil, nil, nil, nil])
        puts "Services on #{ring_server.__drburi}"
        services.each do |service|
          puts "#{service[0]}: #{service[1]} on #{service[2].__drburi} - #{service[3]}"
        end
      end
      
    end # services
    
  end # ring_server
end # mack

alias_task "mack:ring_server:restart", "mack:ring_server:stop", "mack:ring_server:start"