class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @new_student = Student.new
    @students = @user.students
  end
end
