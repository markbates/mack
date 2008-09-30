module Mack
  module Logging # :nodoc:

    class ColorLayout < Mack::Logging::BasicLayout # :nodoc:

      def format(event)
        if event.data.match(/^(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP)/)
          return Mack::Utils::Ansi::Color.wrap(configatron.log.colors.db, super(event))
        else
          color = configatron.log.colors.retrieve(event.level_name.downcase.to_sym, nil)
          if color
            return Mack::Utils::Ansi::Color.wrap(color, super(event))
          else
            return super(event)
          end
        end
      end

    end # ColorLayout

  end # Logging
end # Mack