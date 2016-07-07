include TerraformRakeTasks::Util

desc "Bootstrap terraform running environment from scratch"
task :bootstrap do
  Rake::Task['setup:reset'].invoke
  Rake::Task['setup:s3'].invoke
  Rake::Task['init'].invoke
  Rake::Task['get'].invoke
end

namespace :setup do
  task :env do
    next if File.exists?('.env')

    FileUtils.cp '../.env.example',  '.env'
    puts "Copied ../.env.example to .env, please update with local configration"
  end

  task :reset do
    next unless File.exists?(local_env_state)

    puts "Found existing local state file, removing"
    FileUtils.rm_rf local_env_state
  end

  task :s3 do
    require 'aws-sdk'
    if tf_bucket.exists?
      puts "#{ENV['S3_BUCKET']} already exists"
    else
      tf_bucket.create({ acl: "private" })
      puts "Created #{ENV['S3_BUCKET']} s3 bucket"
    end
  end
end
