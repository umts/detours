require 'rails_helper'

describe Route do
  describe 'the factory' do
    it 'works' do
      expect { create :route }.not_to raise_error
    end
  end
end
