class RemoveCompleteFromTasks < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE tasks SET completed_at = updated_at WHERE complete AND completed_at IS NULL"
    remove_column :tasks, :complete
  end

  def down
    add_column :tasks, :complete, :boolean
    execute "UPDATE tasks SET complete = (completed_at IS NOT NULL)"
  end
end
