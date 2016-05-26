desc "Initializes terraform remote state"
task :init do
  if File.exist?(local_env_state)
    puts "** State for #{tf_env} already exists!".colorize(:red)
    next
  end

  backend_config_params = {
    bucket: ENV['S3_BUCKET'],
    key:    remote_env_state,
    region: ENV['S3_REGION']
  }

  backend_config = backend_config_params.map{|k,v| "-backend-config=\"#{k}=#{v}\""}
  sh("terraform remote config -backend=s3 #{backend_config.join(" ")}")
end

# desc "Fetches state from remote"
# task :fetch do
#   tf_state         = ".terraform/terraform.tfstate"
#   puts "** Updating state for ENV=#{ENV['AAEP_ENV']}".colorize(:green)
#
#   FileUtils.rm(env_state) if File.exist?(env_state)
#   FileUtils.rm(tf_state) if File.exist?(tf_state)
#
#   begin
#   bucket = aaep_tf_bucket
#   bucket.object(remote_env_state).get(response_target: env_state)
#
#   FileUtils.ln_s(File.basename(env_state), tf_state, force: true)
#
#   rescue Aws::S3::Errors::NoSuchKey
#   puts "** Unable to fetch remote state for ENV=#{ENV['AAEP_ENV']}".colorize(:red)
#   puts "** Generating new state"
#   # Rake::Task['init'].invoke
#   # retry
#   end
# end

%w(plan show get destroy).each do |t|
  desc "Run 'terraform #{t}'"
  task t.to_sym do
    Rake::Task['get'].invoke  # Rake::Task['fetch'].invoke
    sh("terraform #{t}", verbose: false)
  end
end

desc "Generate dependenecy graph"
task :graph do
  Rake::Task['get'].invoke
  require 'fileutils'
  FileUtils.rm_f('graph.png') if File.exist?('graph.png')
  sh "terraform graph -draw-cycles -module-depth=0 | dot -Tpng > graph.png"
end

desc "Apply Terraform Plan"
task :apply do
  fail "Commit and push your changes before applying" if uncommitted_changes?
  Rake::Task['get'].invoke
  sh("terraform apply", verbose: false)
end

task "Update Modules"
task :get do
  sh("terraform get -update=true", verbose: false)
end
