require 'google/calendar/calendar'
class UsersController < ApplicationController
  before_action :check_and_update_token

  def show
    @user = User.find(params[:id])
    @new_student = Student.new
    @students = @user.students
    @calendar = Calendar.new(@user.auth_token)
    @upcoming_events = @calendar.upcoming_events
    @past_events = @calendar.past_events
    @new_appointment = Appointment.new
    @appointments = @user.appointments
  end

  private

  def check_and_update_token
    current_user.check_auth_token
  end
end
