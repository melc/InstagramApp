class OmniauthCallbacks::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def instagram
    generic_callback( 'instagram' )
  end
  def facebook
    generic_callback( 'facebook' )
  end
  def twitter
    generic_callback( 'twitter' )
  end
  def google_oauth2
    generic_callback( 'google_oauth2' )
  end

  def generic_callback( provider )
    @photostream = Photostream.find_for_oauth env["omniauth.auth"]
    @user = @photostream.user || current_user

    if @user.nil?
      @user = User.create( email: @photostream.email || "" )
      @photostream.update_attribute( :user_id, @user.id )
    end

    if @user.email.blank? && @photostream.email
      @user.update_attribute( :email, @photostream.email)
    end

    if @user.persisted?
      @photostream.update_attribute( :user_id, @user.id )
      # This is because we've created the user manually, and Device expects a
      # FormUser class (with the validations)
      @user = FormUser.find @user.id

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when omniauth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
