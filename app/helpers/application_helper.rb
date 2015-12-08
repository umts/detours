module ApplicationHelper
  def format_datetime(datetime, options = {})
    case options[:format]
    when :iCal then datetime.utc.strftime '%Y%m%dT%H%M%SZ'
    else datetime.strftime '%A, %B %e, %Y, %l:%M %P'
    end
  end

  def parse_american_date(date)
    Date.strptime(date, '%m/%d/%Y')
  end
end
