class AuthenticationController < ApplicationController
  before_action :verify_authentication, only: [:sign_out]

  def sign_in
    if params.has_key?(:api_code)
      access_token = FrontdeskApiHelper.get_access_token(params[:api_code])
      if access_token
        user_data = FrontdeskApiHelper.get_user_details(access_token)
        user = User.find_by_id(user_data['id'])
        if user == nil
          user = User.new(:id => user_data['id'])
        end
        user.api_token = access_token
        user.update(user_params(user_data))
        
        @session = Session.create(:user_id => user.id)
        return render json: @session, status: :ok
      end
    end

    render json: {error: 'bad credentials'}, status: :unauthorized
  end

  def sign_out
    session = AuthenticationHelper.get_session_from_auth_token(request)
    if session
      session.destroy
      return head :no_content
    end
    head :unauthorized
  end

  private

  def user_params(params)
    authorized_keys = ['first_name', 'last_name', 'middle_name', 'birthdate', 'email', 'avatar']
    params.select do |key, value|
      authorized_keys.include?(key)
    end
  end
end

  