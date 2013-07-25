require 'spec_helper'

describe Tenant do
  context 'creation' do
    let(:tenant) { create(:tenant) }

    it 'should be valid' do
      tenant.should be_valid
    end
  end
end
