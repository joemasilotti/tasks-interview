require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }

  def sign_in
    post session_path, params: {session: {email: user.email, password: user.password}}
  end

  describe "POST /tasks" do
    it "creates the task" do
      sign_in

      expect { post tasks_path, params: {task: {title: "Buy milk"}} }
        .to change(Task, :count).by(1)
      expect(response).to redirect_to(tasks_path)
    end

    it "shows a flash with the errors when the title is blank" do
      sign_in

      expect { post tasks_path, params: {task: {title: "", description: "Two percent"}} }
        .not_to change(Task, :count)

      expect(response).to have_http_status(:unprocessable_content)
      page = Capybara.string(response.body)
      expect(page).to have_text("Title can't be blank")
      expect(page).to have_field("Description", with: "Two percent")
    end
  end

  describe "PATCH /tasks/:id" do
    it "updates the task" do
      task = create(:task)
      sign_in

      patch task_path(task), params: {task: {title: "Renamed"}}

      expect(task.reload.title).to eq("Renamed")
      expect(response).to redirect_to(tasks_path)
    end

    it "shows a flash with the errors when the title is blank" do
      task = create(:task, title: "Original")
      sign_in

      patch task_path(task), params: {task: {title: ""}}

      expect(response).to have_http_status(:unprocessable_content)
      expect(Capybara.string(response.body)).to have_text("Title can't be blank")
      expect(task.reload.title).to eq("Original")
    end
  end
end
