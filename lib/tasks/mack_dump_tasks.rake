namespace :mack do
  
  namespace :dump do

    desc "Dumps out the configuration for the specified environment."
    task :config => :environment do
      fcs = app_config.instance.instance_variable_get("@final_configuration_settings")
      conf = {}
      fcs.each_pair do |k, v|
        unless v.is_a?(Application::Configuration::Namespace)
          conf[k.to_s] = v unless k.to_s.match("__")
        end
      end
      pp conf
    end # config
    
    desc "Show all the routes available"
    task :routes => :environment do
      include Mack::Routes::Urls
      puts ""
      puts "Routes:"
      
      routes = Mack::Routes::RouteMap.instance.routes_list
      routes.each do |r|
        # pp r.inspect
        pat = r.original_pattern.blank? ? '/' : r.original_pattern
        pat << "(.:format)"
        opts = r.options.dup
        meth = opts[:method]
        opts.delete(:method)
        puts "#{pat.rjust(50)}\t#{meth.to_s.upcase}\t#{opts.inspect.ljust(0)}"
      end
      puts ""
      puts "-" * 125
      puts "Route helper methods:"
      
      url_methods = Mack::Routes::Urls.protected_instance_methods.collect {|x| x if x.match(/_url$/)}.compact
      url_methods.sort.each do |meth|
        unless meth.match(/_full_url$/) || meth.match(/_distributed_url$/) || meth == "droute_url"
          puts "#{meth.rjust(50)}\t#{self.send(meth)}"
        end
      end
      puts ""
    end # routes

  end # dump

end # mack

alias_task :routes, "mack:dump:routes"  