require 'rake'
require 'terraform-rake-tasks/util'

module TerraformRakeTasks
  class Tasks
    def self.load_tasks!
      tasks_path = File.expand_path("../tasks", __FILE__)
      Dir.glob(File.join(tasks_path, "*.rake")).each do |task|
        load(task)
      end
    end
  end
end