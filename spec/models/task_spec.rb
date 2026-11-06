require "rails_helper"

RSpec.describe Task, type: :model do
  it "has a valid factory" do
    expect(build(:task)).to be_valid
  end

  it "requires a title" do
    task = build(:task, title: "")

    expect(task).not_to be_valid
    expect(task.errors[:title]).to include("can't be blank")
  end

  it "is valid without an assignee" do
    expect(build(:task, assignee: nil)).to be_valid
  end

  it "is valid with an existing user as assignee" do
    expect(build(:task, assignee: create(:user))).to be_valid
  end

  it "is invalid when the assignee does not exist" do
    task = build(:task, assignee_id: 0)

    expect(task).not_to be_valid
    expect(task.errors[:assignee]).to be_present
  end
end
