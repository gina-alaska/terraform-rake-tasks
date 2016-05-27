# Terraform Rake Tasks

## Usage

### Gemfile
```ruby
gem 'terraform-rake-tasks', git: 'https://github.com/gina-alaska/terraform-rake-tasks'
```

### Rakefile
```ruby
require 'terraform-rake-tasks/tasks'

TerraformRakeTasks::Tasks.load_tasks!
```
