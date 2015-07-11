class Calendar
  def initialize(token)
    @token = token
  end

  def client
    return @client if @client.present?
    @client = Google::APIClient.new(
      application_name: 'Advise Me',
      application_version: '1'
    )
    @client.authorization.access_token = @token
    @client
  end

  def service
    @service ||= client.discovered_api('calendar', 'v3')
  end

  def user_events
    page_token = nil
    result = client.execute(:api_method => service.events.list,
                            :parameters => {'calendarId' => 'primary'})
    events = []
    while true
      raw_events = result.data.items
      raw_events.each do |e|
        events << Calendar::Event.new(e)
      end
      if !(page_token = result.data.next_page_token)
        break
      end
      result = client.execute(:api_method => service.events.list,
                              :parameters => {'calendarId' => 'primary',
                                              'pageToken' => page_token})
    end
    events
  end

  def upcoming_events
    # call user_events to make sure
    # everytime we change query parameters(upcoming or past events)
    # a new API call is made to update events
    events = user_events
    upcoming_events = []
    now = Time.now.to_i
    events.each do |event|
      if event.raw_end_time.to_i >= now
        upcoming_events << event
      end
    end
    upcoming_events
  end

  def past_events
    events = user_events
    past_events = []
    now = Time.now.to_i
    events.each do |event|
      if event.raw_end_time.to_i <= now
        past_events << event
      end
    end
    past_events
  end

  Event = Struct.new(:event_hash) do

    def raw_start_time
      event_hash['start']['dateTime']
    end

    def raw_end_time
      event_hash['end']['dateTime']
    end

    def formatted_start_time
      event_hash['start']['dateTime'].strftime('%A, %b %d at %I:%M %p')
    end

    def formatted_end_time
      event_hash['end']['dateTime'].strftime('%A, %b %d at %I:%M %p')
    end

    def summary
      event_hash['summary']
    end

    def event_link
      event_hash['htmlLink']
    end
  end
end
