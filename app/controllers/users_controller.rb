class UsersController < ApplicationController
  before_action :check_and_update_token

  def show
    @user = User.find(params[:id])
    @new_student = Student.new
    @students = @user.students
    @upcoming_events = Calendar.new(@user.auth_token).upcoming_events
  end

  private

  def check_and_update_token
    current_user.check_auth_token
  end
end
