require 'rails_helper'

describe User do
  describe 'factory' do
    it 'works' do
      expect { create :user }.not_to raise_error
    end
  end
end
