module Mack
  module Portlet
    class Unpacker < Mack::Utils::RegistryMap
      
      def unpack(key, force = false)
        m = self.registered_items[key.to_sym]
        if m
          m.call((force || false))
        else
          Mack.search_path(key.to_sym, false).each do |path|
            Dir.glob(File.join(path, '**/*')).each do |f|
              f = File.expand_path(f)
              dest = f.gsub(path, Mack::Paths.send(key))
              FileUtils.mkdir_p(File.dirname(dest))
              if File.file?(f)
                cp = File.exists?(dest) ? force : true
                if cp
                  FileUtils.cp(f, f.gsub(path, Mack::Paths.send(key)), :verbose => true) if cp
                else
                  puts "Skipping: #{dest}"
                end
              end
            end
          end
        end
      end
      
      def initial_state
        {}
      end
      
    end # Unpacker
  end # Portlet
end # Mack