require "google/calendar/calendar"
class StudentsController < ApplicationController

  before_action :find_user
  before_action :check_and_update_token

  def new
    @student = Student.new
  end

  def create
    @student = @user.students.build(student_params)

    if @student.save
      respond_to do |format|
        format.js { flash[:success] = "Student successfully added" }
      end
    else
      respond_to do |format|
        format.js { flash[:error] = "Student could not be saved. #{@student.clean_error_messages}" }
      end
    end
  end

  def show
    @student = current_user.students.find_by_id(params[:id])
    @calendar = Calendar.new(@user.auth_token)
    @appointments = @calendar.appointments_with_attendee(@student.email)
    @upcoming_appointments = @calendar.upcoming_appointment_with_attendee(@appointments)
    @past_appointments = @calendar.past_appointment_with_attendee(@appointments)
  end

  private

  def find_user
    @user = current_user
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :year, :major)
  end

  def check_and_update_token
    @user.check_auth_token
  end
end
