require 'rails_helper'
RSpec.describe SlotsController, type: :controller do
  let!(:user) { create(:user) }
  before(:each) do
    add_request_headers(user)
  end

  describe "POST #create" do
    it "creates new slot" do
      post :create, params: { user_id: user.id, available_days: Date.today, available_time: "13:00" }
      debugger
      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT #update" do
    it "updates slot" do
      slot = FactoryBot.create(:slot)
      put :update, params: { id: slot.id, slot: { available_time: "12:00" } }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    context "slot exists" do
      let(:slot) { FactoryBot.create(:slot) }
      it "details of slot" do
        get :show, params: { id: slot.id }
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include("slot_id", "doctor_name", "available_date", "time_slot")
      end
    end

    context "slot not exist" do
      it "no slot" do
        expect {
          get :show, params: { id: 999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
 end

  describe "DELETE #destroy" do
    context "slot exists" do
      it "delete slot" do
        slot = FactoryBot.create(:slot)
        delete :destroy, params: { id: slot.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "slot not exist" do
      it "raises error" do
        expect {
          delete :destroy, params: { id: 999 } 
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST #booked" do
    let(:slot) { create(:slot) }

    context "when the slot is not booked" do
      it "books the slot" do
        post :booked, params: { id: slot.id }
        expect(response).to have_http_status(:ok)
        expect(slot.reload.booked).to eq(true)
      end
    end

    context "when the slot is already booked" do
      it "returns an error message" do
        slot.update(booked: true)
        post :booked, params: { id: slot.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["error"]).to eq("This slot is already booked")
      end
    end
  end
end
