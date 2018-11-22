module Abilities
  class AdminRole
    include CanCan::Ability

    def initialize(_admin)
      cannot [:create, :edit, :destroy], Role
      cannot [:create, :edit, :destroy], Admin
    end

  end
end
