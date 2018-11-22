module Abilities
  class Everyone
    include CanCan::Ability

    def initialize(_admin)
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    end

  end
end
