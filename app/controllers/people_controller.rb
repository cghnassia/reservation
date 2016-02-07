class PeopleController < ApplicationController
  before_action :verify_authentication

  def index
    @users = User.all
    return render :json => @users, :status => :ok
  end

  def show
    begin
      if params[:id] == 'me'
        @user = AuthenticationHelper.get_user_from_auth_token(request)
      else
        @user = User.find(params[:id])
      end
    rescue ActiveRecord::RecordNotFound
      return render :json => {}, :status => :not_found
    end

    return render :json => @user, :status => :ok
  end
end
