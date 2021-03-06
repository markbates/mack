Rake::RDocTask.new do |rd|
  rd.main = "README"
  files = Dir.glob("**/*.rb")
  files = files.collect {|f| f unless f.match("test/") || f.match("doc/") || f.match("private/") || f.match("spec/") || f.match("gems/") }.compact
  files << "README"
  files << "CHANGELOG"
  rd.rdoc_files = files
  rd.rdoc_dir = "doc"
  rd.options << "--line-numbers"
  rd.options << "--inline-source"
  rd.options << '--exclude=gems/'
  rd.title = "Mack Framework"
end