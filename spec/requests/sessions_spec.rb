require "rails_helper"

RSpec.describe "Sessions", type: :request do
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
end
