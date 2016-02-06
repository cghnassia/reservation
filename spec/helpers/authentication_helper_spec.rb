require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AuthenticationHelper. For example:
#
# describe AuthenticationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AuthenticationHelper, type: :helper do

  describe "parse_token" do
    it "return correctly the token" do
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"qwertyuiop\""
      expect(AuthenticationHelper.parse_token(@request)).to eq('qwertyuiop')
    end

    it "return false if the request does not contain HTTP_AUTHORIZATION" do
      expect(AuthenticationHelper.parse_token(@request)).to be(false)
    end

    it "return false if the request contain an not good formatted HTTP_AUTHORIZATION" do
      @request.env["HTTP_AUTHORIZATION"] = "notavalidhttpauthorization"
      expect(AuthenticationHelper.parse_token(@request)).to be(false)
    end
  end

  describe "get_session_from_auth_token" do
    it "return correctly the session" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.create(:user_id => user.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
      expect(AuthenticationHelper.get_session_from_auth_token(@request)).to eq(session)
    end

    it "return false if the request does not contain HTTP_AUTHORIZATION" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.create(:user_id => user.id)
      expect(AuthenticationHelper.get_session_from_auth_token(@request)).to be(false)
    end

    it "return false if the request contain an invalid token" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.new(:user_id => user.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
      expect(AuthenticationHelper.get_session_from_auth_token(@request)).to be(false)
    end
  end

  describe "get_user_from_auth_token" do
    it "return correctly the user" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.create(:user_id => user.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
      expect(AuthenticationHelper.get_user_from_auth_token(@request)).to eq(user)
    end

    it "return false if the request does not contain HTTP_AUTHORIZATION" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.create(:user_id => user.id)
      expect(AuthenticationHelper.get_user_from_auth_token(@request)).to be(false)
    end

    it "return false if the request contain an invalid token" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.new(:user_id => user.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
      expect(AuthenticationHelper.get_session_from_auth_token(@request)).to be(false)
    end
  end

  describe "get_user_from_auth_token" do
    it "return true for authenticated user" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.create(:user_id => user.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
      expect(AuthenticationHelper.authenticated?(@request)).to be(true)
    end

    it "return false for unauthenticated user" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.new(:user_id => user.id)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
      expect(AuthenticationHelper.authenticated?(@request)).to be(false)
    end

    it "return false for user with timeout session" do
      user = User.create(:email => 'foo@mail.com', :password => 'secret', :activated => true)
      session = Session.create(:user_id => user.id, :updated_at => DateTime.now - 1.day)
      @request.env["HTTP_AUTHORIZATION"] = "Token token=\"#{session.auth_token}\""
      expect(AuthenticationHelper.authenticated?(@request)).to be(false)
    end
  end
end
