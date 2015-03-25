support_dir = File.expand_path('../support', __FILE__)
Dir[support_dir + '/**/*.rb'].each do |file|
  require file
end
