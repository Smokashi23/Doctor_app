class SlotsController < ApplicationController
  load_and_authorize_resource
  def index
    @slots = Slot.where(booked: false).where("available_days >= ?", Date.today).order(:available_days, :available_time).map.with_index(1) do |slot, index|
      start_time = slot.available_time.strftime("%H:%M")
      end_time = (slot.available_time + 1.hour).strftime("%H:%M")
      available_days = slot.available_days.strftime('%d-%m-%y')
      user_name = "#{slot.user.first_name} #{slot.user.last_name}" if slot.user
      {
        "slot_id": slot.id,
        "Doctor_name": user_name,
        "available_date": "#{available_days}",
        "slot_#{index}": " #{start_time} to #{end_time}"
      }
    end
    render json: @slots
  end
    
  def create
    available_time = Time.zone.parse(slot_params[:available_time])
    if available_time.hour < 10 || available_time.hour >= 18
      render json: { error: I18n.t('slots.errors.invalid_time_range') }, status: :unprocessable_entity
      return
    end
    @slot = Slot.new(slot_params.merge(available_time: available_time))
    if @slot.save
      render json: @slot, status: :created
    else
      render json: @slot.errors, status: :unprocessable_entity
    end
  end
    
  def booked
    @slot = Slot.find(params[:id]) 
    if @slot.booked
      render json: { error: I18n.t('slots.errors.slot_already_booked')}, status: :unprocessable_entity
    else
      @slot.update(booked: true)
      appointment = current_user.appts.create(slot_id: @slot.id, status: "booked")
      render json: { message: I18n.t('slots.sucess.booked'), appointment: appointment }, status: :ok
    end
  end

  def show
    @slot = Slot.find_by(id: params[:id])
    if @slot
      start_time = @slot.available_time.strftime("%H:%M")
      end_time = (@slot.available_time + 1.hour).strftime("%H:%M")
      available_date = @slot.available_days.strftime('%d-%m-%y')
      user_name = @slot.user ? "#{@slot.user.first_name} #{@slot.user.last_name}" : nil
      render json: {
      slot_id: @slot.id,
      doctor_name: user_name,
      available_date: available_date,
      time_slot: "#{start_time} to #{end_time}"
    }, status: :ok
    else
      render json: { error: 'Slot not found' }, status: :not_found
    end
  end

  def destroy
    @slot = Slot.find(params[:id])
    @slot.destroy
    render json: { message: 'Slot deleted successfully' }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Slot not found' }, status: :not_found
  end

  def update
    @slot = Slot.find(params[:id])
    if @slot.update(slot_params)
      render json: @slot, status: :ok
    else
      render json: @slot.errors, status: :unprocessable_entity
    end
    rescue ActiveRecord::RecordNotFound
    render json: { error: 'Slot not found' }, status: :not_found
  end
  
  private
    def set_slot
      @slot = Slot.find(params[:id])
    end

    def slot_params
      params.require(:slot).permit(:user_id, :available_days, :available_time)
    end

    # def user_params 
    #   params.require(:user).permit(:email, :password, :first_name, :last_name, :age, :specialization,:role_id)
    # end

end