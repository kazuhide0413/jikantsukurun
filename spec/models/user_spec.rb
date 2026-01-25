require "rails_helper"

RSpec.describe User, type: :model do
  it "factoryが有効である" do
    expect(build(:user)).to be_valid
  end

  it "nameが必須" do
    user = build(:user, name: "")
    expect(user).to be_invalid
  end
end
