class RequireTaskTitle < ActiveRecord::Migration[8.1]
  def change
    change_column_null :tasks, :title, false, "Untitled"
  end
end
