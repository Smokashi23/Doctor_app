class Ability
  include CanCan::Ability

  def initialize(user) 
    can :login, User
    can :update, User
    can :show, User
    if user.admin?
      can :manage, :all
      can :create_doctor, User
    elsif user.doctor?
      can :create, Slot
      can :update, Slot
      can :destroy, Slot
      can :show, Slot
      can :index, Appointment
      can :show, Appointment
      can :update, Appointment
      cannot :create_doctor, User
    elsif user.patient?
      can :book, Slot
      cannot :create, Slot
      cannot :index, Appointment
      can :index, Slot
      can :show, Slot
      cannot :create_doctor, User
    end
  end
end

