module Mack
  module Logging # :nodoc:

    class ColorLayout < Mack::Logging::BasicLayout # :nodoc:

      def format(event)
        message = super(event)
        if message.match(/(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP)/)
          return Mack::Utils::Ansi::Color.wrap(configatron.mack.log.colors.db, message)
        else
          color = configatron.mack.log.colors.retrieve(event.level_name.downcase.to_sym, nil)
          if color
            return Mack::Utils::Ansi::Color.wrap(color, message)
          else
            return message
          end
        end
      end

    end # ColorLayout

  end # Logging
end # Mack