class Event
  attr_reader :event_hash

  def initialize(event_hash)
    @event_hash = event_hash
  end

  FULL_DATE_FORMAT = "%A, at %I:%M %p"
  MONTH = "%B"
  DATE = "%d"
  DAY = "%A"

  def raw_start_time
    event_hash["start"]["dateTime"]
  end

  def raw_end_time
    event_hash["end"]["dateTime"]
  end

  def month
    raw_start_time.strftime(MONTH)
  end

  def date
    raw_start_time.strftime(DATE)
  end

  def day
    raw_start_time.strftime(DAY)
  end

  def formatted_start_time
    raw_start_time.strftime(FULL_DATE_FORMAT)
  end

  def formatted_end_time
    raw_end_time.strftime(FULL_DATE_FORMAT)
  end

  def summary
    event_hash["summary"]
  end

  def description
    event_hash["description"]
  end

  def event_link
    event_hash["htmlLink"]
  end

  def attendees
    event_hash["attendees"][0].email if event_hash["attendees"][0]
  end

  def upcoming_event_sort
    raw_end_time.to_i >= Time.now.to_i
  end

  def past_event_sort
    raw_end_time.to_i <= Time.now.to_i
  end
end
