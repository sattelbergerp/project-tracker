class Task < ActiveRecord::Base

  has_many :project_tasks
  has_many :projects, through: :project_tasks

end
