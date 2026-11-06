require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }

  def sign_in
    post session_path, params: {session: {email: user.email, password: user.password}}
  end

  describe "GET /tasks" do
    it "shows each task's assignee" do
      create(:task, assignee: create(:user, name: "Ada Lovelace"))
      sign_in

      get tasks_path

      expect(response.body).to include("Ada Lovelace")
    end

    it "loads assignees without an N+1 query" do
      create_list(:task, 3) { |task| task.update!(assignee: create(:user)) }
      sign_in

      user_queries = 0
      counter = ->(*, payload) { user_queries += 1 if payload[:sql].include?('FROM "users"') }
      ActiveSupport::Notifications.subscribed(counter, "sql.active_record") { get tasks_path }

      expect(user_queries).to eq(2)
    end
  end

  describe "GET /tasks/:id/edit" do
    it "shows a blank option followed by every user" do
      other_user = create(:user)
      task = create(:task)
      sign_in

      get edit_task_path(task)

      page = Capybara.string(response.body)
      expect(page).to have_select("Assigned to:", options: ["", *[user, other_user].map(&:name).sort])
    end
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

    it "assigns the task to a user" do
      task = create(:task)
      sign_in

      patch task_path(task), params: {task: {assignee_id: user.id}}

      expect(response).to redirect_to(tasks_path)
      expect(task.reload.assignee).to eq(user)
    end

    it "unassigns the task when blank" do
      task = create(:task, assignee: user)
      sign_in

      patch task_path(task), params: {task: {assignee_id: ""}}

      expect(task.reload.assignee).to be_nil
    end

    it "rejects an assignee that does not exist" do
      task = create(:task)
      sign_in

      patch task_path(task), params: {task: {assignee_id: 0}}

      expect(response).to have_http_status(:unprocessable_content)
      expect(Capybara.string(response.body)).to have_text("Assignee must exist")
      expect(task.reload.assignee).to be_nil
    end
  end
end
