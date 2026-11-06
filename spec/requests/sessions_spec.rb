require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /session/new" do
    it "prefills the seeded credentials in development" do
      allow(Rails.env).to receive(:development?).and_return(true)

      get new_session_path

      page = Capybara.string(response.body)
      expect(page).to have_field("Email", with: "user1@tern.travel")
      expect(page).to have_field("Password", with: "abc123")
    end

    it "leaves the fields blank outside development" do
      get new_session_path

      page = Capybara.string(response.body)
      expect(page).to have_css("#session_email:not([value])")
      expect(page).to have_css("#session_password:not([value])")
    end
  end

  describe "POST /session" do
    it "signs in and shows the tasks" do
      post session_path, params: {session: {email: user.email, password: user.password}}

      expect(response).to redirect_to(tasks_path)
      follow_redirect!
      expect(Capybara.string(response.body)).to have_css("h1", text: "Tasks")
    end

    it "re-renders the form without the seeded credentials when the login is invalid" do
      allow(Rails.env).to receive(:development?).and_return(true)

      post session_path, params: {session: {email: user.email, password: "wrong"}}

      page = Capybara.string(response.body)
      expect(page).to have_css("#session_email:not([value])")
      expect(page).to have_css("#session_password:not([value])")
      expect(session[:user_id]).to be_nil
    end
  end
end
