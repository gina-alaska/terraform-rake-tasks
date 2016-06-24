DANGER_MESSAGE = "(DANGER: Will cause existing resources to be rebuilt)".freeze
include TerraformRakeTasks::Util
require 'aws-sdk'

namespace :keys do
  desc "Generate new ssh keys #{DANGER_MESSAGE}"
  task :generate do
    Rake::Task["keys:create_directory"].invoke
    local_key = File.join(ssh_key_path, key_file)
    sh("ssh-keygen -b 4096 -N '' -C 'AWS Deploy Key #{Time.now}' -f #{local_key}")
  end

  desc "Upload keys to S3"
  task :upload do
    [key_file, public_key_file].each do |file|
      key = "ssh/#{file}"
      filename = File.join(ssh_key_path, file)
      tf_bucket.object(key).put(:body => File.open(filename), :server_side_encryption => "aws:kms")
    end
  end

  desc "Rotate ssh keys #{DANGER_MESSAGE}"
  task :rotate do
    Rake::Task['keys:generate'].invoke
    Rake::Task['keys:upload'].invoke
  end

  desc "Fetch new ssh keys from AWS"
  task :fetch do
    Rake::Task["keys:create_directory"].invoke

    tempfile = File.join(ssh_key_path, "aws-#{Time.now.to_i}")

    [key_file, public_key_file].each do |file|
      keyfile = File.join(ssh_key_path, file)

      tf_bucket.object("ssh/#{file}").get(response_target: tempfile)
      FileUtils.mv(tempfile, keyfile)
      FileUtils.rm_f(tempfile) if File.exist?(tempfile)
    end
    File.chmod(0600, File.join(ssh_key_path, key_file))
  end

  task :create_directory do
    FileUtils.mkdir_p(ssh_key_path) unless File.exist?(ssh_key_path)
  end

  def key_file
    "aws-#{tf_project}-#{tf_env}"
  end

  def public_key_file
    "#{key_file}.pub"
  end
end
