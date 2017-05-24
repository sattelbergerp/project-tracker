class ChangeTaskCompletedByToDate < ActiveRecord::Migration
  def change
    change_column :tasks, :complete_by, :date
  end
end
