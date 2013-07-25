require 'spec_helper'

describe Invite do

  context 'creation' do

    let(:invite) { build(:invite) }

    it 'should be valid' do
      invite.should be_valid
    end

    it 'should not be valid without a tenant' do
      invite.tenant = nil
      invite.should_not be_valid
    end

    it 'should not be valid without a recipient email' do
      invite.recipient_email = nil
      invite.should_not be_valid
    end

    it 'should not be valid with an invalid tenant id' do
      invite.tenant_id = 999
      invite.should_not be_valid
    end
  end
end