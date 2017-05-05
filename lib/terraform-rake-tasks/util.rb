module TerraformRakeTasks
  module Util
    def sh_with_clean_env(*args)
      # Bundler.with_clean_env do
      sh(*args)
      # end
    end

    def tf_env
      (ENV['TERRAFORM_ENV'] || ENV['TF_ENV'] || "dev").freeze
    end

    def tf_project
      (ENV['TF_PROJECT'] || "tf").freeze
    end

    def uncommitted_changes?
      false
    end

    def aws_client
      Aws::S3::Client.new(credentials: fetch_credentials!)
    end

    def fetch_credentials!
      Aws::SharedCredentials.new(profile_name: (ENV['AWS_PROFILE'] || 'default'))
    end

    def tf_bucket
      s3 = Aws::S3::Resource.new(client: aws_client)
      s3.bucket(ENV['S3_BUCKET'])
    end

    def remote_env_state
      "terraform/#{tf_project}-#{tf_env}.json"
    end

    def local_env_state
      ".terraform/terraform.tfstate"
    end

    def ssh_key_path
      File.expand_path((ENV['SSH_KEY_PATH'] || File.join(ENV['HOME'], '.terraform/ssh')))
    end
  end
end
