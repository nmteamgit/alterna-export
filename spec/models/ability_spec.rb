require "rails_helper"
require "cancan/matchers"

describe Ability do
  subject(:ability){ Ability.new(admin) }

  context "when is a superadmin" do
    let(:admin){ create(:admin, name: 'test1', role: Role.find_by_name('superadmin')) }
    it{ is_expected.to be_able_to(:create, admin) }
    it{ is_expected.to be_able_to(:edit, admin) }
    it{ is_expected.to be_able_to(:destroy, admin) }
  end

  context "when is a admin" do
    let(:admin){ create(:admin, name: 'test2', role: Role.find_by_name('admin')) }
    it{ is_expected.not_to be_able_to(:create, admin) }
    it{ is_expected.not_to be_able_to(:edit, admin) }
    it{ is_expected.not_to be_able_to(:destroy, admin) }
  end
end
