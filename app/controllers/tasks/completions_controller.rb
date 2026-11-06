class Tasks::CompletionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_task

  def create
    if @task.update(completed_at: Time.current)
      redirect_to tasks_path
    else
      redirect_to tasks_path, alert: "Could not complete task."
    end
  end

  def destroy
    if @task.update(completed_at: nil)
      redirect_to tasks_path
    else
      redirect_to tasks_path, alert: "Could not undo task."
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end
end
