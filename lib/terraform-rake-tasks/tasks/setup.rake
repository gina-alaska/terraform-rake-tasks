include TerraformRakeTasks::Util

namespace :setup do
  task :s3 do
    require 'aws-sdk'
    if tf_bucket.exists?
      puts "#{ENV['S3_BUCKET']} already exists"
    else
      tf_bucket.create
      puts "Created #{ENV['S3_BUCKET']} s3 bucket"
    end
  end
end
