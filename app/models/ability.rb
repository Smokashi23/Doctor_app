class Ability
  include CanCan::Ability

  def initialize(user) 
    can :login, User
    can :update, User
    if user.admin?
      can :manage, :all
    elsif user.doctor?
      can :create, Slot
      can :update, Slot
      can :destroy, Slot
      can :show, Slot
      can :index, Appointment
      can :show, Appointment
      can :update, Appointment
    elsif user.patient?
      can :booked, Slot
      cannot :create, Slot
      cannot :index, Appointment
      can :index, Slot
      can :show, Slot
    end
  end
end

