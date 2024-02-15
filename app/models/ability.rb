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
      can :index, Appt
      can :show, Appt
      can :update, Appt
    elsif user.patient?
      can :booked, Slot
      cannot :create, Slot
      cannot :index, Appt
      can :index, Slot
      can :show, Slot
    end
  end
end

