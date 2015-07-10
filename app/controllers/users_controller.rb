class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @new_student = Student.new
    @students = @user.students
    @events = Calendar.new(@user.auth_token).user_events
  end
end
