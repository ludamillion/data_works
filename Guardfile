rspec_opts = {
  :failed_mode => :none,
  :cmd => 'bundle exec rspec'
}

guard :rspec, rspec_opts do
# watch /spec/ files
  watch(%r{^spec/(.+).rb$}) do |m|
    "spec/#{m[1]}.rb"
  end
end
