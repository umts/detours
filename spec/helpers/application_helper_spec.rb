require 'rails_helper'
include ApplicationHelper

describe ApplicationHelper do
  before :each do
    @datetime = DateTime.current
    Timecop.freeze @datetime
  end
  describe 'format_date_time' do
    context 'format given'  do
      context 'iCal format' do
        it 'renders the time in iCal format' do
          expect(format_datetime @datetime, format: :iCal)
            .to eql @datetime.utc.strftime('%Y%m%dT%H%M%SZ')
        end
      end
    end
    context 'no format given' do
      it 'renders the default format' do
        expect(format_datetime @datetime)
          .to eql @datetime.strftime('%A, %B %e, %Y, %l:%M %P')
      end
    end
  end

  describe 'parse_american_date' do
    it 'parses a slash-separated, poorly ordered date' do
      expect(parse_american_date('03/31/2013')).to eql Date.parse('2013-03-31')
    end
  end
  after :each do
    Timecop.return
  end
end
