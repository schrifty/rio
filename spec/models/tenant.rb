require 'spec_helper'

describe Tenant do
  context 'creation' do
    let(:tenant) { create(:tenant) }

    it 'should be valid' do
      tenant.should be_valid
    end

    it 'should not be valid without a display name' do
      tenant.display_name = nil
      tenant.should_not be_valid
    end
  end
end
