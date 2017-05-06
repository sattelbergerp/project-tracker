class CreateProjectTasks < ActiveRecord::Migration
  def change
    create_table :project_tasks do |t|
      t.integer :project_id
      t.integer :task_id
    end
  end
end
