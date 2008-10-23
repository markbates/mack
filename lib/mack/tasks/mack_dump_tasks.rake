namespace :mack do
  
  namespace :dump do

    desc "Dumps out the configuration for the specified environment."
    task :config => :environment do
      puts Mack::Configuration.dump
    end # config
    
    desc "Show all the routes available"
    task :routes => :environment do
      spacer

      include Mack::Routes::Urls
      
      # Get all the defined routes
      routes = Mack::Routes::RouteMap.instance.routes_list
      # save the error mappings for display later:
      errors = routes.delete(:errors)
      
      # set up an [] to house our routes in their proper order:
      urls = []
      # :get, :post, :put, :delete
      routes.each do |section|
        section[1].each do |r|
          # get each route
          urls << r
        end
      end
      
      # Add the default routes to the list:
      Mack::Routes::RouteMap.instance.default_routes_list.each do |r|
        urls << r
      end

      unless urls.empty?
        section_header "Routes"
        # Sort the urls based on when they were inserted :
        urls.sort.each do |r|
          r.options.delete(:runner_block)
          print_nice(r.path + "(.:format)", r.options.delete(:method).to_s.upcase, r.options.inspect)
        end
        spacer
      end
      
      unless errors.empty?
        section_header "Error Mappings"
        errors.each do |k, v|
          print_nice(k, '', v.inspect)
        end
        spacer
      end
      
      url_methods = Mack::Routes::Urls.protected_instance_methods.collect {|x| x if x.match(/_url$/)}.compact
      unless url_methods.empty?
        section_header 'Route Helper Methods'
        
        @request = Mack::Request.new(Rack::MockRequest.env_for("http://www.example.com"))
        url_methods.sort.each do |meth|
          unless meth.match(/(full|distributed)_url$/)
            print_nice(meth, '', self.send(meth))
          end
        end
        spacer
      end
      
    end # routes
    
    private
    def spacer
      puts ''
      puts '-' * 125
    end
    
    def print_nice(a, b, c)
      puts "#{a.to_s.rjust(60)}\t#{b.to_s}\t#{c.to_s.ljust(0)}"
    end
    
    def section_header(name)
      puts "\n#{name}:"
    end

  end # dump

end # mack

alias_task :routes, "mack:dump:routes"