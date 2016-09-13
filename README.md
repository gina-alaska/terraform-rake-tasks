# Terraform Rake Tasks

Rake tasks for managing Terraform with shared S3 State.


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

## Configuration

This gem uses the following ENV variables:

| Variable Name | purpose | default |
| ------------- | ------- | ------- |
| TF_PROJECT    | Name of the terraform project. Should be set to prevent name collisions | tf |
| TF_ENV        | Terraform Environment. Used for multi-environment repositories. | dev |
| AWS_PROFILE   | Name of AWS Profile to use | default | 
| S3_BUCKET     | Name of S3 Bucket to store shared data in | ** NO DEFAULT ** |
| SSH_KEY_PATH  | Path to store ssh credentials | $HOME/.terraform/ssh |

