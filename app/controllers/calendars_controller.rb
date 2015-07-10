require 'calendar'
class CalendarsController < ApplicationController

  def user_events
    calendar = Calendar.new
    calendar.user_events
  end

  # List all events
end
