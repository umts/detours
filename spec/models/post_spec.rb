require 'rails_helper'

describe Post do
  describe 'the factory' do
    it 'works' do
      expect { create :post }.not_to raise_error
    end
  end
end
