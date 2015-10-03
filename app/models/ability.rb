class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, [Goal, User, Comment]
    if user.regular?
      can :create, [Goal, Comment]
      can :manage, [Goal, Comment, Token], user_id: user.id
      can :manage, User, id: user.id
      cannot :destroy, Goal
    elsif user.admin?
      can :manage, :all
    end
  end
end
