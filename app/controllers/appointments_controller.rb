require 'google/calendar/create_event'
class AppointmentsController < ApplicationController

  before_action :find_user

  def new
    @appointment = Appointment.new
  end

  def create
    @appointment = @user.appointments.build(appointment_params)
    @calendar = Calendar.new(@user.auth_token)

    if @appointment.save
      @new_event = @calendar.new_event(@appointment)
      # make API call to refresh upcoming_events list
      # this could be moved to js to refresh page before
      # or right after modal closes
      @calendar.upcoming_events
      flash.now[:success] = "Appointment successfully created"
    else
      flash.now[:error] = "Appointment could not be saved"
    end
  end

  private

  def find_user
    @user = current_user
  end

  def appointment_params
    params.require(:appointment).permit(:summary,
                                        :description,
                                        :start_time,
                                        :end_time,
                                        :attendees
                                        )
  end
end
