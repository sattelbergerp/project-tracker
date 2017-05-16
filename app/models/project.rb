class Project < ActiveRecord::Base
  belongs_to :user
  has_many :project_tasks
  has_many :tasks, through: :project_tasks
end
