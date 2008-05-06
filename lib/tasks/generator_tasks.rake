namespace :generator do
  
  desc "Lists all the generators available"
  task :list => :environment do
    list = "\nAvailable Generators:\n\n"
    Object.constants.sort.each do |g|
      g = g.constantize
      if g.respond_to?(:superclass) && g.superclass == Genosaurus
        list << g.name
        list << "\n\t" << "rake generate:#{g.name.underscore}\n"
      end
    end
    list << "\n\n"
    ENV["__generator_list"] = list
    puts list
  end
  
end