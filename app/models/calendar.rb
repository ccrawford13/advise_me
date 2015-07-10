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

  Event = Struct.new(:event_hash) do
    def start_time
      event_hash['start']['dateTime'].strftime('%A, %b %d at %I:%M %p')
    end

    def end_time
      event_hash['end']['dateTime'].strftime('%A, %b %d at %I:%M %p')
    end

    def summary
      event_hash['summary']
    end
  end
end
