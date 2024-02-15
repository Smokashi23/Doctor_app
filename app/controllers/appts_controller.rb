class ApptsController < ApplicationController
  load_and_authorize_resource
  def index
    @user = current_user
    if @user.admin?
      @appts = Appt.includes(:slot, :user).map do |appointment|
        {
          "id": appointment.id,
          "slot_id": appointment.slot.id,
          "Doctor_name": "#{appointment.slot.user.first_name} #{appointment.slot.user.last_name}",
          "Patient_name": "#{appointment.user.first_name} #{appointment.user.last_name}",
          "bookeded_at": appointment.created_at.strftime('%d-%m-%Y %H:%M')
        }
      end
    elsif @user.doctor?
      @appts = Appt.includes(:slot, :user).where(slots: { user_id: @user.id }).map do |appointment|
        {
          "id": appointment.id,
          "slot_id": appointment.slot.id,
          "Patient_name": "#{appointment.user.first_name} #{appointment.user.last_name}",
          "bookeded_at": appointment.created_at.strftime('%d-%m-%Y %H:%M')
        }
      end
    end
    if @appts.nil? || @appts.empty?
      render json: { message: "No appointments" }, status: :ok
    else
      render json: @appts
    end
 end
  
  def show
    @appt = Appt.find(params[:id])
    render json: @appt
  end

  def update
    begin
      @appointment = Appt.find(params[:id])
      @status = @appointment.status
      if @status == "confirmed"  
        @appointment.update(status: params[:status])
        render json: { message: "Apologies, appointment has been cancelled" }, status: :ok
      else
        render json: { message: "No one booked appointment for this slot" }, status: :ok
      end
    rescue ActiveRecord::RecordNotFound
      render json: { message: "Appointment not found" }, status: :not_found
    end
  end
  
  def appt_params
    params.permit(:id)
  end
  
end
