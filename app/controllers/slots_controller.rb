class SlotsController < ApplicationController
  load_and_authorize_resource

  def index
    # debugger
    @slots = Slot.where(booked: false).where("available_days >= ?", Date.today)
                .order(:available_days, :available_time)
                .map { |slot| format_slot(slot) }
    render json: @slots 

  end

  # def index
  #   debugger
  #   @slots = Slot.where(booked: false).where('available_days >= ?', Date.today).order(:available_days, :available_time)
  #   render json: @slots
  # end
  

  def create
    available_time = Time.zone.parse(slot_params[:available_time])
    unless valid_time_range?(available_time)
      return render_error(I18n.t('slots.errors.invalid_time_range'), :unprocessable_entity)
    end
    @slot = Slot.new(slot_params.merge(available_time: available_time))
    if @slot.save
      render json: @slot, status: :created
    else
      render json: @slot.errors, status: :unprocessable_entity
    end
  end

  def book
    @slot = Slot.find(params[:slot_id])
    if @slot.booked
      render_error(I18n.t('slots.errors.slot_already_booked'), :unprocessable_entity)
    else
      book_slot
    end
  end

  def my_slots
    @booked_slots = current_user.appointments.includes(:slot).where(status: "booked").map(&:slot)
    render json: @booked_slots.map { |slot| format_slot(slot) }, status: :ok
  end
  

  def show
    @slot = Slot.find_by(id: params[:id])
    if @slot
      render json: format_slot(@slot), status: :ok
    else
      render_error('Slot not found', :not_found)
    end
  end

  def destroy
    @slot = Slot.find_by(id: params[:id])
    if @slot
      @slot.destroy
      render json: { message: 'Slot deleted successfully' }, status: :ok
    else
      render_error('Slot not found', :not_found)
    end
  end

  def update
    @slot = Slot.find_by(id: params[:id])
    if @slot
      if @slot.update(slot_params)
        render json: @slot, status: :ok
      else
        render json: @slot.errors, status: :unprocessable_entity
      end
    else
      render_error('Slot not found', :not_found)
    end
  end

  private

  def format_slot(slot)
    {
      slot_id: slot.id,
      doctor_name: full_name(slot.user),
      available_date: slot.available_days.strftime('%d-%m-%y'),
      time_slot: "#{slot.available_time.strftime('%H:%M')} to #{(slot.available_time + 1.hour).strftime('%H:%M')}"
    }
  end

  def full_name(user)
    user ? "#{user.first_name} #{user.last_name}" : nil
  end

  def valid_time_range?(time)
    time.hour >= 10 && time.hour < 18
  end

  def book_slot
    appointment = Appointment.create(slot_id: @slot.id, user_id:current_user.id,status:"booked")
    @slot.update(booked:true)
    render json: { message: I18n.t('slots.success.booked'), appointment: appointment }, status: :ok
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end

  def slot_params
    params.require(:slot).permit(:user_id, :available_days, :available_time)
  end
end
