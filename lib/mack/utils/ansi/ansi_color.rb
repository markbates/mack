module Mack
  module Utils # :nodoc:
    module Ansi # :nodoc:
      
      module Color
        
        def self.wrap(color, string)
          if configatron.mack.log.use_colors
            return "\e[#{Mack::Utils::Ansi::ColorRegistry.registered_items[color.to_sym] || 0}m#{string}\e[0m"
          end
          return string
        end
        
      end # Color
      
      class ColorRegistry < Mack::Utils::RegistryMap
        def initial_state
          { :blue => 34, :black => 30, :red => 31, :green => 32, :yellow => 33, :magenta => 35,
            :purple => 35, :cyan => 36, :white => 37, :clear => 0 }
        end
      end
      
    end # Ansi
  end # Utils
end # Mack