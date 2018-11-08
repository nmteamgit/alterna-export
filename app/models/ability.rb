class Ability
  include CanCan::Ability

  def initialize(admin)
    admin ||= Admin.new

    merge Abilities::Everyone.new(admin)

    if admin.superadmin_role?
      merge Abilities::SuperadminRole.new(admin)
    elsif admin.admin_role?
      merge Abilities::AdminRole.new(admin)
    end
  end
end
