require 'time'
require 'date'

class GoogleBase

  attr_reader :token

  def initialize(token)
    @token = token
  end

  def client
    return @client if @client.present?
    @client = Google::APIClient.new(
      application_name: 'Advise Me',
      application_version: '1'
    )
    @client.authorization.access_token = token
    @client
  end

  def service
    # Throw error if service is not provided by child classes
    fail 'Not implemented'
  end
end

class Calendar < GoogleBase
  def service
    @service ||= client.discovered_api('calendar', 'v3')
  end

  def user_events
    page_token = nil
    result = client.execute(:api_method => service.events.list,
                            :parameters => {'calendarId' => 'primary'})
    events = []
    cancelled_events = []
    # iterate through all of the user's events
    while true
      raw_events = result.data.items
      raw_events.each do |e|
        # small guard clause to avoid cancelled items
        # that have no summary or data fields from
        # raising errors. -> could be refactored further
        unless e['status'] == 'cancelled'
          events << Calendar::Event.new(e)
        end
      end
      if !(page_token = result.data.next_page_token)
        break
      end
      result = client.execute(api_method: service.events.list,
                              parameters: { 'calendarId' => 'priamary',
                                           'pageToken' => page_token })
    end
    events
  end

  def new_event(event_obj)
    # event hash with required parameters for calendar API
    event = {
      'summary' => "#{event_obj.summary}",
      'description' => "#{event_obj.description}",
      'start' => {
        'dateTime' => "#{event_obj.start_time.to_datetime.rfc3339}",
        'timeZone' => 'America/Chicago',
        # rfc3339 is the dateTime format Google API prefers
        # this could be ideally refactored to clean up event hash
      },
      'end' => {
        'dateTime' => "#{event_obj.end_time.to_datetime.rfc3339}",
        'timeZone' => 'America/Chicago',
      },
      'attendees' => [
        {'email' => "#{event_obj.attendees}"},
      ],
      'reminders' => {
        'useDefault' => true,
      },
    }

    # call client method to instantiate the client
    # and service method to set client service to calendar
    result = client.execute(
      :api_method => service.events.insert,
      :parameters => {
        :calendarId => 'primary' },
      :body_object => event)
    event = result.data
  end

  def upcoming_events
    map_events(user_events) {|event| event.upcoming_event_sort }
  end

  def past_events
    map_events(user_events) {|event| event.past_event_sort }
  end

  def appointments_with_attendee(attendee_email)
    map_events(user_events) {|event| event.attendees == attendee_email }
  end

  def upcoming_appointment_with_attendee(attendee_appointments)
    map_events(attendee_appointments) {|event| event.upcoming_event_sort }
  end

  def past_appointment_with_attendee(attendee_appointments)
    map_events(attendee_appointments) {|event| event.past_event_sort }
  end

  def map_events(events)
    # Map events and yield to block
    events.map do |event|
      event if yield(event)
    end.compact
  end

  Event = Struct.new(:event_hash) do
    DATE_FORMAT = '%A, %b %d at %I:%M %p'

    def raw_start_time
      event_hash['start']['dateTime']
    end

    def raw_end_time
      event_hash['end']['dateTime']
    end

    def formatted_start_time
      raw_start_time.strftime('%A, %b %d at %I:%M %p')
    end

    def formatted_end_time
      raw_end_time.strftime('%A, %b %d at %I:%M %p')
    end

    def summary
      event_hash['summary']
    end

    def description
      event_hash['description']
    end

    def event_link
      event_hash['htmlLink']
    end

    def attendees
      event_hash['attendees'][0].email if event_hash['attendees'][0]
    end
    
    def upcoming_event_sort
      raw_end_time.to_i >= Time.now.to_i
    end

    def past_event_sort
      raw_end_time.to_i <= Time.now.to_i
    end
  end
end
