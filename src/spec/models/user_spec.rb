# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '#create' do
    subject(:user) { build(:user) }

    context 'with valid password' do
      it 'success' do
        expect(user).to be_valid
      end
    end

    context 'with weak password' do
      subject(:user) { build(:user, password: '123qwerty') }

      it 'failure' do
        expect(user).to be_invalid
      end
    end
  end
end
