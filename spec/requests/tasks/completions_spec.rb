require "rails_helper"

RSpec.describe "Task completions", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }

  def sign_in
    post session_path, params: {session: {email: user.email, password: user.password}}
  end

  describe "POST /tasks/:task_id/completion" do
    it "timestamps the task as completed" do
      task = create(:task)
      sign_in

      freeze_time do
        post task_completion_path(task)

        expect(task.reload.completed_at).to eq(Time.current)
      end
      expect(response).to redirect_to(tasks_path)
    end

    it "redirects to sign in when logged out" do
      task = create(:task)

      post task_completion_path(task)

      expect(response).to redirect_to(new_session_path)
      expect(task.reload.completed_at).to be_nil
    end
  end

  describe "DELETE /tasks/:task_id/completion" do
    it "clears the completed timestamp" do
      task = create(:task, :completed)
      sign_in

      delete task_completion_path(task)

      expect(task.reload.completed_at).to be_nil
      expect(response).to redirect_to(tasks_path)
    end

    it "redirects to sign in when logged out" do
      task = create(:task, :completed)

      delete task_completion_path(task)

      expect(response).to redirect_to(new_session_path)
      expect(task.reload.completed_at).to be_present
    end
  end

  describe "GET /tasks" do
    it "shows a Complete button for incomplete tasks and Undo with strikethrough for completed ones" do
      create(:task, title: "Open task")
      create(:task, :completed, title: "Done task")
      sign_in

      get tasks_path

      page = Capybara.string(response.body)
      expect(page).to have_css("h2:not(.line-through)", text: "Open task")
      expect(page).to have_css("h2.line-through", text: "Done task")
      expect(page).to have_button("Complete", count: 1)
      expect(page).to have_button("Undo", count: 1)
    end
  end
end
