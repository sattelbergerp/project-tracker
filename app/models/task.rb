class Task < ActiveRecord::Base

  belongs_to :user
  has_many :project_tasks
  has_many :projects, through: :project_tasks

  validates :name, presence: true
  validates :user, presence: true

  def complete_by_str
    return "" unless complete_by
    dif = complete_by.jd - Date.today.jd
    if dif > 0
      "#{dif} days from now"
    elsif dif < 0
      "#{dif} days ago"
    else
      "today"
    end
  end

end
