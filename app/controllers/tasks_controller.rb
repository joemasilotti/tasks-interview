class TasksController < ApplicationController
  before_action :authenticate_user

  def index
    @tasks = Task.order(:id)
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path
    else
      @tasks = Task.order(:id)
      flash.now[:alert] = @task.errors.full_messages.to_sentence
      render :index, status: :unprocessable_content
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to tasks_path
    else
      flash.now[:alert] = @task.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @task = Task.find(params[:id])

    if @task.destroy
      redirect_to tasks_path
    else
      redirect_to tasks_path, alert: "Could not delete task."
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
