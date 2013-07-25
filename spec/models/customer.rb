require "spec_helper"

describe Customer do

  context 'creation' do
    let(:customer) { build(:customer) }

    it 'should build a valid customer' do
      customer.should be_valid
    end

    it 'should not be valid without a tenant' do
      customer.tenant = nil
      customer.should_not be_valid
    end

    it 'should not be valid with an invalid tenant id' do
      customer.tenant_id = 000
      customer.should_not be_valid
    end
  end

end