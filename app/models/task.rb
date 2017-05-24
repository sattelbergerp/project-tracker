class Task < ActiveRecord::Base

  belongs_to :user
  has_many :project_tasks
  has_many :projects, through: :project_tasks

  validates :name, presence: true
  validates :user, presence: true

end
