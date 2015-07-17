class AppointmentsController < ApplicationController

  before_action :find_user

  def new
    @appointment = Appointment.new
  end

  def create
    @new_appointment = Appointment.new
    @appointment = @user.appointments.build(appointment_params)
    @calendar = Calendar.new(@user.auth_token)

    if @appointment.save
      @new_event = @calendar.new_event(@appointment)
      # make API call to refresh upcoming_events list
      @calendar.upcoming_events
      flash.now[:success] = "Appointment successfully created"
    else
      flash.now[:error] = @appointment.errors.full_messages.join("<br/>").html_safe
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
