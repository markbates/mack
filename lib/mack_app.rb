run_once do
  [:hello, :core, :gems, :plugins, :lib, :initializers, :routes, :app, :helpers].each do |f|
    require File.join_from_here('mack', 'boot', "#{f}.rb")
  end
end