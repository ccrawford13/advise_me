class RegistrationsController < Devise::RegistrationsController
  skip_before_action :authenticate_user!

  private

  def sign_up_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :position,
                                 :organization,
                                 :email,
                                 :password,
                                 :password_confirmation
                                 )
  end

  def after_inactive_sign_up_path_for(resource)
    if @current_user
      user_path(@current_user)
    else
      new_user_session_path
    end
  end

end
