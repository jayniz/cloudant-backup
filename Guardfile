# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :cli => "--color", :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/dummy/app/models/(.+)\.rb$})                    { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})                             { "spec" }
  watch('spec/dummy/config/routes.rb')                           { "spec/routing" }
  watch('spec/dummy/app/controllers/application_controller.rb')  { "spec/controllers" }
end


guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end
