class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, User
    can :edit, [:dashboard, Content], user_id: user.id
    can :edit, [:dashboard, Comment], user_id: user.id
    can :manage, [:dashboard, User], id: user.id
    can [:inbox, :preferences, :notifications, :show], [:dashboard, User], id: user.id
    can [:profile], User
    can [:followers, :following], User do |u|
      user.see_contacts u
    end
    can :comment, User do |u|
      u != user && user.following?(u)
    end
  end
end
