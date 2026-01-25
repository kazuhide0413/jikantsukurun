require "rails_helper"

RSpec.describe "Root", type: :request do
  it "GET / が200を返す" do
    get "/"
    expect(response).to have_http_status(:ok)
  end
end
