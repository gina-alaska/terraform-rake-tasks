require_relative "../util"

DANGER_MESSAGE = "(DANGER: Will cause existing resources to be rebuilt)".freeze

namespace :keys do
  SSHKEY_PATH = File.expand_path("../../../.ssh", __FILE__).freeze
  desc "Generate new ssh keys #{DANGER_MESSAGE}"
  task :generate do
    Rake::Task["keys:create_directory"].invoke
    keyfile = File.expand_path("#{SSHKEY_PATH}/aaep-aws")

    sh("ssh-keygen -b 2048 -N '' -C 'AWS Deploy Key #{Time.now}' -f #{keyfile}")
  end

  desc "Upload keys to S3"
  task :upload do
    require 'aws-sdk'

    bucket = aaep_tf_bucket

    %w(aaep-aws aaep-aws.pub).each do |file|
      key = "ssh/#{file}"
      filename = File.join(SSHKEY_PATH, file)
      bucket.object(key).put(:body => File.open(filename), :server_side_encryption => "aws:kms")
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

    bucket = aaep_tf_bucket
    tempfile = File.join(SSHKEY_PATH, "aws-#{Time.now.to_i}")

    %w(aaep-aws aaep-aws.pub).each do |file|
      keyfile = File.join(SSHKEY_PATH, file)

      bucket.object("ssh/#{file}").get(response_target: tempfile)
      FileUtils.mv(tempfile, keyfile)
      FileUtils.rm_f(tempfile) if File.exist?(tempfile)
    end
    File.chmod(0600, File.join(SSHKEY_PATH, "aaep-aws"))
  end

  task :create_directory do
    FileUtils.mkdir_p(SSHKEY_PATH) unless File.exist?(SSHKEY_PATH)
  end
end
