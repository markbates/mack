class PassengerGenerator < Genosaurus
  
  def after_generate
    FileUtils.mkdir_p(File.join(Mack.root, "tmp"))
    File.open(File.join(Mack.root, "tmp", "README"), "w") do |f|
      f.puts "Temporary folder."
      f.puts "Do not delete this folder if you are using Phusion Passenger (mod_rails) to host your Mack application."
    end
  end
  
end