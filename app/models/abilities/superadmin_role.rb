module Abilities
  class SuperadminRole
    include CanCan::Ability

    def initialize(_admin)
      can :manage, :all
    end

  end
end
