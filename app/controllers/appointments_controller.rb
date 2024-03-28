class AppointmentsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @user = current_user
    if @user.admin?
      @appts = Appointment.includes(:slot, :user).where.not(status: 'cancelled').map do |appointment|
        {
          "id": appointment.id,
          "slot_id": appointment.slot.id,
          "Doctor_name": "#{appointment.slot.user.first_name} #{appointment.slot.user.last_name}",
          "Patient_name": "#{appointment.user.first_name} #{appointment.user.last_name}",
          "bookeded_at": appointment.created_at.strftime('%d-%m-%Y %H:%M')
        }
      end
    elsif @user.doctor?
      @appts = Appointment.includes(:slot, :user).where(slots: { user_id: @user.id }, status: 'booked').map do |appointment|
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
    @appt = Appointment.find_by(id: params[:id]) 
    if @appt
      render json: @appt
    else
      render json: { message: I18n.t('messages.no_appointment_found') }, status: :not_found
    end
  end

  def update
    @appointment = Appointment.find_by(id: params[:id])
    if @appointment
      if @appointment.status == 'booked' && @appointment.update(status: 'cancelled')
        render json: { message: I18n.t('messages.appointment_cancelled') }, status: :ok
      else
        render json: { message: I18n.t('messages.no_appointment_booked') }, status: :unprocessable_entity
      end
    else
      render json: { message: I18n.t('messages.no_appointment_found') }, status: :not_found
    end
  end
  
  private
  
  def appt_params
    params.require(:appointment).permit(:status)
  end
end
