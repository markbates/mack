module Mack
  class PageCacher
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      puts "Mack::PageCacher start"
      request = Mack::Request.new(env)
      response = Mack::Response.new(env)
      key = request.path_info.dup
      key << "?" << request.query_string unless request.query_string.blank?
      puts "key: #{key}"
      cache = Cachetastic::Caches::PageCache.get(key)
      puts "cache: #{cache.inspect}"
      if cache
        response.write(cache)
        response.finish
        # return
      else
        result = @app.call(env)
        result_response = get_response_from_result(result)
        Cachetastic::Caches::PageCache.set(key, result_response.instance_variable_get("@body").first)
        puts "Mack::PageCacher end"
        result
      end
    end
    
    def get_response_from_result(result)
      puts result
      if result.instance_variable_get("@app")
        get_response_from_result(result.instance_variable_get("@app"))
      else
        if result.is_a?(Array)
          get_response_from_result(result.last)
        else
          return result.instance_variable_get("@response")
        end
      end
    end
    
  end # PageCacher
end # Mack