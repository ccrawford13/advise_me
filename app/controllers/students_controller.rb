require "google/calendar/calendar"
class StudentsController < ApplicationController

  before_action :find_user
  before_action :check_and_update_token
  before_action :find_student, only: [:show, :update]
  before_action :sort_notes, only: [:show]

  def new
    @student = Student.new
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
    @calendar = Calendar.new(@user.auth_token)
    @new_appointment = Appointment.new
    @appointments = @calendar.appointments_with_attendee(@student.email)
    @upcoming_appointments = @calendar.upcoming_appointment_with_attendee(@appointments)
    @past_appointments = @calendar.past_appointment_with_attendee(@appointments)
    @new_note = Note.new
    @notes = @sorted_notes.paginate(page: params[:page], per_page: 10)
  end

  def update
    if @student.update_attributes(student_params)
      flash.now[:success] = "Student successfully updated"
    else
      flash.now[:error] = @student.errors.full_messages.join("<br/>").html_safe
    end
  end

  def import
    @student = Student.import(params[:user_id], params[:file])
    flash[:success] = "Students successfully added"
    redirect_to user_path(@user)
    rescue StandardError => e
      flash[:error] = "Students could not be added." " #{e}"
      redirect_to user_path(@user)
  end

  private

  def find_user
    @user = current_user
  end

  def find_student
    @student = @user.students.find_by_id(params[:id])
  end

  def sort_notes
    @sorted_notes = @student.notes.order("date DESC")
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :year, :major, :file)
  end

  def check_and_update_token
    @user.check_auth_token
  end
end
