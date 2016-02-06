module FrontdeskApiHelper
  include HTTParty
  mattr_reader :client_id
  mattr_reader :client_secret
  mattr_reader :client_callback

	base_uri 'https://lutece.frontdesk.com'
  format :json
	@@client_id = ENV['frontdesk_api_key']
  @@client_secret = ENV['frontdesk_api_secret']
  @@client_callback = ENV['frontdesk_api_callback']

  def self.get_headers(access_token)
    return {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}"
    }
  end

	def self.get_access_token(code)
	  query = {
	    :grant_type => 'authorization_code',
	    :code => code,
      :redirect_uri => @@client_callback,
      :client_id => @@client_id,
      :client_secret => @@client_secret
	  }

    data = self.post('/oauth/token', :query => query)
    if data
      return data['access_token']
    end

    return false
  end

  def self.get_user_details(access_token)
    data = self.get('/people/me', :headers => self.get_headers(access_token))
    if data
      result = data["people"][0]
      result['avatar'] = data['people'][0]['profile_photo']['x400']
      result.delete('name')
      result.delete('profile_photo')
      result.delete('person_custom_fields')
      result.delete('secondary_info_field')
      return result
    end

    return false
  end

end