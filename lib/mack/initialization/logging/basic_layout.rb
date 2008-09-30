module Mack
  module Logging # :nodoc:
    
    class BasicLayout < ::Logging::Layout # :nodoc:

      def format(event)
        obj = format_obj(event.data)
        sprintf("%*s:\t[%s]\t%s\n", ::Logging::MAX_LEVEL_LENGTH, ::Logging::LNAMES[event.level], Time.now.strftime(configatron.log.time_format), obj)
      end

    end # BasicLayout

  end # Logging
end # Mack