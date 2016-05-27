require_relative 'lib/terraform-rake-tasks/version.rb'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'terraform-rake-tasks'
  s.version     = TerraformRakeTasks::VERSION
  s.summary     = 'Terraform Rake Tasks'
  s.description = 'Tasks for managing terraform with environments @ GINA'

  s.required_ruby_version     = '>= 2.2.2'
  s.required_rubygems_version = '>= 1.8.11'

  s.license = 'MIT'

  s.author   = 'UAF GINA'
  s.email    = 'support@gina.alaska.edu'
  s.homepage = 'http://gina.alaska.edu'

  s.files = %w(Gemfile Rakefile LICENSE README.md) + Dir.glob("*.gemspec") +
     Dir.glob("lib/**/*", File::FNM_DOTMATCH).reject {|f| File.directory?(f) }
  s.require_path = 'lib'

  s.add_dependency 'aws-sdk', '~> 2.3', '>= 2.3.0'
  s.add_dependency 'colorize', '~> 0.7.0', '>= 0.7.0'
  s.add_dependency 'dotenv', '~> 2.1.0', '>= 2.1.0'
  s.add_dependency 'rake', '~> 11.1.0', '>= 11.1.0'
end