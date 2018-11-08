require 'rails_helper'

describe Admin do
  describe 'has associations intact' do
    it { is_expected.to belong_to(:role) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:role_id) }
    subject { FactoryGirl.build(:admin) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'methods' do
    it 'should return true or false based on his/her role' do
      admin = create(:admin, role: Role.find_by_name('admin'))
      superadmin = create(:admin, role: Role.find_by_name('superadmin'))
      expect(admin.admin_role?).to be_truthy
      expect(admin.superadmin_role?).to be_falsey

      expect(superadmin.admin_role?).to be_falsey
      expect(superadmin.superadmin_role?).to be_truthy
    end
  end
end
