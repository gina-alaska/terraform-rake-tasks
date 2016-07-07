include TerraformRakeTasks::Util

desc "Initializes terraform remote state"
task :init do
  next if File.exist?(local_env_state)

  backend_config_params = {
    bucket: ENV['S3_BUCKET'],
    key:    remote_env_state,
    region: ENV['S3_REGION']
  }

  backend_config = backend_config_params.map{|k,v| "-backend-config=\"#{k}=#{v}\""}
  Bundler.with_clean_env do
    sh("terraform remote config -backend=s3 #{backend_config.join(" ")}")
  end
end

%w(plan show get destroy).each do |t|
  desc "Run 'terraform #{t}'"
  task t.to_sym do
    Rake::Task['init'].invoke
    Bundler.with_clean_env do
      sh("terraform #{t}", verbose: false)
    end
  end
end

desc "Generate dependenecy graph"
task :graph do
  Rake::Task['init'].invoke
  require 'fileutils'
  FileUtils.rm_f('graph.png') if File.exist?('graph.png')
  Bundler.with_clean_env do
    sh "terraform graph -draw-cycles -module-depth=0 | dot -Tpng > graph.png"
  end
end

desc "Apply Terraform Plan"
task :apply do
  fail "Commit and push your changes before applying" if uncommitted_changes?
  Rake::Task['init'].invoke
  Bundler.with_clean_env do
    sh("terraform apply", verbose: false)
  end
end

task "Update Modules"
task :get do
  Bundler.with_clean_env do
    sh("terraform get -update=true", verbose: false)
  end
end
