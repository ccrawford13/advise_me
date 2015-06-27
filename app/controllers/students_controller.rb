class StudentsController < ApplicationController

  before_action :find_user

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

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :email, :year, :major)
  end

end
