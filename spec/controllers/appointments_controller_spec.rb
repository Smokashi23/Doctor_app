require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  let!(:user) { create(:user) }
  before(:each) do
    add_request_headers(user)
  end
  describe "GET index" do
    it "returns a success response for admin" do
      admin_user = create(:user, :admin) 
      get :index
      expect(response).to be_successful
    end

    it "returns a success response for doctor" do
      doctor_user = create(:user, :doctor) 
      get :index
      expect(response).to be_successful
    end

    it "returns a success response for other users" do
      user = create(:user) 
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET show" do
    it "returns a success response" do
      appt = create(:appt) 
      get :show, params: { id: appt.id }
      expect(response).to be_successful
    end
  end

  describe "PUT update" do
    context "with valid parameters" do
      it "updates the requested appt" do
        appt = create(:appt) 
        put :update, params: { id: appt.id, status: "cancelled" }
        appt.reload
        expect(appt.status).to eq("cancelled")
      end

      it "returns a success response" do
        appt = create(:appt) 
        put :update, params: { id: appt.id, status: "cancelled" }
        expect(response).to be_successful
      end
    end

    context "with invalid parameters" do
      it "returns a success response if status is not 'confirmed'" do
        appt = create(:appt, status: "cancelled") 
        put :update, params: { id: appt.id, status: "cancelled" }
        expect(response).to have_http_status(:ok)
      end
    
      it "returns a success response if appointment not found" do
        expect {
          put :update, params: { id: 999 } 
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
