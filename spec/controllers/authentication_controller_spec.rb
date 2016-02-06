require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do

  #describe "POST sign_in" do
  #  it "returns http success" do
  #    user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
  #    post :sign_in, :user => {:email => user.email, :password => 'secret'}
  #    expect(response).to have_http_status(:success)
  #    data = JSON.parse(response.body)
  #    expect(data['session']['user_id']).to eq(user.id)
  #    expect(data['session']['auth_token']).to eq(user.sessions.last.auth_token)
  #  end
#
  #  it "sign_in with bad credentials should return unauthorized" do
  #    User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
  #    post :sign_in, :user => {:email => 'foo@mail.com', :password => 'wrongpassword'}
  #    expect(response).to have_http_status(:unauthorized)
  #  end
#
  #  it "sign_in with wrong user should return unauthorized" do
  #    post :sign_in, :user => {:email => 'foo@mail.com', :password => 'secret'}
  #    expect(response).to have_http_status(:unauthorized)
  #  end
#
  #  it "sign_in with unactivated user should return unauthorized" do
  #    User.create(:email => 'foo@mail.com', :password => 'secret', :activated => false)
  #    post :sign_in, :user => {:email => 'foo@mail.com', :password => 'secret'}
  #    expect(response).to have_http_status(:unauthorized)
  #  end
#
  #  it "sign_in without payload should return unauthorized" do
  #    post :sign_in
  #    expect(response).to have_http_status(:unauthorized)
  #  end
  #end

  describe "POST sign_in_oauth" do
    it "returns http success" do
      api_token = 'abc123'

      stub_request(:post, "#{FrontdeskApiHelper.base_uri}/oauth/token")
        .with(:query => hash_including({
          :grant_type => 'authorization_code',
          :code => 'mycode',
          :redirect_uri => FrontdeskApiHelper.client_callback,
          :client_id => FrontdeskApiHelper.client_id,
          :client_secret => FrontdeskApiHelper.client_secret
        })).to_return(:body => {"access_token": api_token}.to_json)

      stub_request(:get, "#{FrontdeskApiHelper.base_uri}/people/me")
        .with(:headers => FrontdeskApiHelper.get_headers(api_token))
        .to_return(:body => {
          "people": [{
            "id": 1,
            "name": "John Staff",
            "first_name": "John",
            "middle_name": nil,
            "last_name": "Staff",
            "email": "johnstaff@example.com",
            "secondary_info_field": "Unlimited Membership",
            "birthdate": "1980-01-01",
            "profile_photo": {
              "x50": "https://d1nqv8xdwxria6.cloudfront.net/uploads/profile_photo/image/f1150c38-5e62-4c4b-a701-473e3f586e1e/image_profile_x50.jpg",
              "x100": "https://d1nqv8xdwxria6.cloudfront.net/uploads/profile_photo/image/f1150c38-5e62-4c4b-a701-473e3f586e1e/image_profile_x100.jpg",
              "x200": "https://d1nqv8xdwxria6.cloudfront.net/uploads/profile_photo/image/f1150c38-5e62-4c4b-a701-473e3f586e1e/image_profile_x200.jpg",
              "x400": "https://d1nqv8xdwxria6.cloudfront.net/uploads/profile_photo/image/f1150c38-5e62-4c4b-a701-473e3f586e1e/image_profile_x400.jpg"
            }, "person_custom_fields": [{
              "id": 1,
              "custom_field_id": 5,
              "name": "Favorite Color",
              "value": "blue"
            }]
          }]
        }.to_json)
      
      post :sign_in_oauth, :code => 'mycode'
      session = User.find(1).sessions.last

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['session']['user_id']).to eq(1)
      expect(JSON.parse(response.body)['session']['auth_token']).to eq(session.auth_token)
    end
  end

  #describe "POST sign out" do
  #  it "returns http success" do
  #    user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
  #    session = Session.create(:user_id => user.id)
  #    @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
  #    post :sign_out
  #    expect(response).to have_http_status(:no_content)
  #  end
#
  #  it "should return http unauthorized if http authorization is not present" do
  #    user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
  #    session = Session.create(:user_id => user.id)
  #    post :sign_out
  #    expect(response).to have_http_status(:unauthorized)
  #  end
#
  #  it "should return http unauthorized if user already signed out" do
  #    user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
  #    session = Session.create(:user_id => user.id)
#
  #  end
  #end

end
