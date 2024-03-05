require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:role) { create(:role)}
  before(:each) do
    user = create(:user, role_id: role.id)
    add_request_headers(user)
  end

  describe "GET #index" do
    let!(:users) { create_list(:user, 4) }

    it "users" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "emails presence" do
      get :index
      users.each do |user|
        expect(response.body).to include(user.email)
      end
    end
  end

  describe "POST /users" do
    context "with valid parameters" do
      let!(:role) { create(:role)}
      let(:valid_params) { { user: attributes_for(:user, role_id: role.id) } }

      it "creates new user" do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { user: { email: "invalid_email" } } }

      it "does not create a new user" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }
    it "deletes the user" do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:no_content)
      expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
 end

  describe "#standards" do
    context "password standards" do
      it "does not add an error" do
        user = User.new(password: "Password@123") 
        user.valid?
        expect(user.errors[:password]).to_not include("Must include at least one digit, one lowercase, and one uppercase letter")
      end
    end
  end
end
