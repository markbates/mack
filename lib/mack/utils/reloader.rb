module Mack
  # Mack::Reloader checks on every request, but at most every +secs+
  # seconds, if a file loaded changed, and reloads it, logging to
  # Mack.logger.debug.

  class Reloader
    def initialize(app, secs = configatron.mack.reload_classes)
      @app = app
      @secs = secs              # reload every @secs seconds max
      @last = Time.now
    end

    def call(env)
      if Time.now > @last + @secs
        Thread.exclusive {
          reload!
          @last = Time.now
        }
      end

      @app.call(env)
    end

    def reload!
      need_reload = $LOADED_FEATURES.find_all { |loaded|
        begin
          if loaded =~ /\A[.\/]/  # absolute filename or 1.9
            abs = loaded
          else
            if configatron.mack.deep_class_reload
              abs = $LOAD_PATH.map { |path| ::File.join(path, loaded) }.find { |file| ::File.exist? file }
            end
          end

          if abs
            ::File.mtime(abs) > @last - @secs  rescue false
          else
            false
          end
        end
      }

      need_reload.each { |l|
        $LOADED_FEATURES.delete l
      }

      need_reload.each { |to_load|
        begin
          if require to_load
            Mack.logger.debug "#{self.class}: reloaded `#{to_load}'"
          end
        rescue LoadError, SyntaxError => e
          raise e                 # Possibly ShowExceptions
        end
      }
      need_reload
    end

  end
end
