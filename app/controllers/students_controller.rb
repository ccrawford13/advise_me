require "google/calendar/calendar"
class StudentsController < ApplicationController

  before_action :find_user
  before_action :check_and_update_token

  def new
    @student = Student.new
  end

  def import
    @student = Student.import(params[:user_id], params[:file])
    flash[:success] = "Students successfully added"
    redirect_to user_path(@user)
    rescue StandardError => e
      flash[:error] = "Students could not be added." " #{e}"
      redirect_to user_path(@user)
  end

  def create
    @student = @user.students.build(student_params)

    if @student.save
      flash.now[:success] = "Student successfully added"
    else
      flash.now[:error] = @student.errors.full_messages.join("<br/>").html_safe
    end
  end

  def show
    @student = @user.students.find_by_id(params[:id])
    @calendar = Calendar.new(@user.auth_token)
    @new_appointment = Appointment.new
    @appointments = @calendar.appointments_with_attendee(@student.email)
    @upcoming_appointments = @calendar.upcoming_appointment_with_attendee(@appointments)
    @past_appointments = @calendar.past_appointment_with_attendee(@appointments)
  end

  def update
    @student = @user.students.find_by_id(params[:id])

    if @student.update_attributes(student_params)
      flash.now[:success] = "Student successfully updated"
    else
      flash.now[:error] = @student.errors.full_messages.join("<br/>").html_safe
    end
  end

  private

  def find_user
    @user = current_user
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :year, :major, :file)
  end

  def check_and_update_token
    @user.check_auth_token
  end
end
