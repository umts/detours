require 'rails_helper'

describe Route do
  describe 'number_and_name' do
    it 'separates number and name with a dash' do
      route = create :route
      expect(route.number_and_name).to eql [route.number, route.name].join ' - '
    end
  end
end
