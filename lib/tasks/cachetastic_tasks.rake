require 'find'
namespace :cachetastic do
  
  task :manipulate_caches => :environment do
    cache_name = ENV['cache_name']
    cache_name = cache_name.camelcase
    action = ENV['cache_action']
    running_time("#{cache_name}.#{action}") do
      case cache_name
      when "All"
        puts "About to work on ALL caches!"
        # force all caches to register themselves:
        ["#{MACK_ROOT}/lib/caches"].each do |dir|
          Find.find(dir) do |f|
            # puts f
            if FileTest.directory?(f) and !f.match(/.svn/)
            else
              if FileTest.file?(f)
                m = f.match(/\/[a-zA-Z\-_]*.rb$/)
                if m
                  model = m.to_s
                  unless model.match("test_")
                    x = model.gsub('/', '').gsub('.rb', '')
                    # puts "x: #{x}"
                    require x
                  end
                end
              end
            end
          end
        end
        caches = Cachetastic::Caches::Base.all_registered_caches.dup
        caches.sort!
        caches.reverse!
        caches.each do |cache|
          do_work(cache, action)
        end
      else
        do_work(cache_name, action)
      end
    end
  end
  
  def do_work(cache, action)
    begin
      puts "Calling: #{cache}.#{action}"
      cache.constantize.send(action)
    rescue MethodNotImplemented => e
      msg = "Cachetastic.rake Warning: cache #{cache} does not implement #{action}. This is probably an error."
      puts msg
      MACK_DEFAULT_LOGGER.warning(msg)
    rescue NoMethodError => e
    rescue Exception => e
      raise e
    end
  end
  
  namespace :page_cache do
    
    desc "Expires the page cache."
    task :expire_all => :environment do
      running_time do("Cachetastic::Caches::PageCache.expire_all")
        Cachetastic::Caches::PageCache.expire_all
      end
    end
    
  end
  
end