require 'rails_helper'

RSpec.describe PeopleController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      users = create_list('user', 10)
      session = create(:session, :user_id => users.first.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""

      get :index
      expect(JSON.parse(response.body)['people'].count).to eq(10)
      expect(response).to have_http_status(:success)
    end

    it "returns unauthorized if user is not authenticated" do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      me = create(:user)
      session = create(:session, :user_id => me.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
      
      user = create(:user)
      get :show, :id => user.id
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['user']['id']).to eq(user.id)
      expect(JSON.parse(response.body)['user']['first_name']).to eq(user.first_name)
      expect(JSON.parse(response.body)['user']['last_name']).to eq(user.last_name)
      expect(JSON.parse(response.body)['user']['middle_name']).to eq(user.middle_name)
      expect(JSON.parse(response.body)['user']['birthdate']).to eq(user.birthdate.iso8601)
      expect(JSON.parse(response.body)['user']['avatar']).to eq(user.avatar)
      expect(JSON.parse(response.body)['user']['email']).to be_nil
      expect(JSON.parse(response.body)['user']['api_token']).to be_nil
    end

    it "returns http success with me as id" do
      me = create(:user)
      session = create(:session, :user_id => me.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""

      get :show, :id => 'me'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['user']['id']).to eq(me.id)
    end

    it "return notfound if user id is not found" do
      me = create(:user)
      session = create(:session, :user_id => me.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""

      get :show, :id => 123
      expect(response).to have_http_status(:not_found)
    end

    it "returns unauthorized if user is not authenticated" do
      user = create(:user)
      get :show, :id => user.id
      expect(response).to have_http_status(:unauthorized)
    end
  end

end
