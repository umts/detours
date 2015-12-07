require 'rails_helper'

describe Route do
  describe 'factory' do
    it 'works' do
      expect { create :route }.not_to raise_error
    end
  end
end
