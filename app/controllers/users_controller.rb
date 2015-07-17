require "google/calendar/calendar"
class UsersController < ApplicationController
  before_action :check_and_update_token
  before_action :find_user
  before_action :sort_students

  def show
    @new_student = Student.new
    @students = @sorted_students.paginate(page: params[:page], per_page: 8)
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

  def find_user
    @user = User.find(params[:id])
  end

  def sort_students
    @sorted_students = @user.student_sort(:last_name)
  end
end
