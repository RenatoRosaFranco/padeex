Dir[File.join(__dir__, "seeds", "*.rb")].sort.each do |file|
  puts "\n==> #{File.basename(file)}"
  load file
end
