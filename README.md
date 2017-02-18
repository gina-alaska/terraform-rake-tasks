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

## Rake tasks provided

```
rake apply          # Apply Terraform Plan
rake bootstrap      # Bootstrap terraform running environment from scratch
rake destroy        # Run 'terraform destroy'
rake dotenv         # Load environment settings from .env
rake get            # Run 'terraform get'
rake graph          # Generate dependenecy graph
rake init           # Initializes terraform remote state
rake keys:fetch     # Fetch new ssh keys from AWS
rake keys:generate  # Generate new ssh keys (DANGER: Will cause existing resources to be rebuilt)
rake keys:rotate    # Rotate ssh keys (DANGER: Will cause existing resources to be rebuilt)
rake keys:upload    # Upload keys to S3
rake plan           # Run 'terraform plan'
rake show           # Run 'terraform show'
```

### `rake bootstrap`

* setup and initialization tasks 
* Sets up terraform modules
* create encrypted s3 bucket - ssh keys and terraform state
 * locked down to (insert details here)
* generates ssh key, if it doesn't exist

### Terraforming

After the bootstrap your usage is via `rake` as a thin wrapper around terraform plan, get, show, and destroy commands.  You can skip that if you source the .env to allow running of terraform directly. (Just don't go wandering about into other environments after that). 
