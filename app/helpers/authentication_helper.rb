module AuthenticationHelper
	TOKEN_TIMEOUT = 12.hours

	def self.authenticated?(request)
	    session = get_session_from_auth_token(request)
	    if session && session.updated_at > (DateTime.now - TOKEN_TIMEOUT)
	        return true
	    end

	    return false
	end

	def self.get_session_from_auth_token(request)
		auth_token = parse_token(request)
		if auth_token
			return Session.find_by(:auth_token => auth_token)
		end

		return false
	end

	def self.get_user_from_auth_token(request)
		session = get_session_from_auth_token(request)
		if session
			return session.user
		end

		return false
	end

	private

	def self.parse_token(request)
	    if request.env['HTTP_AUTHORIZATION']
	      authorization_matches = /Token token="(\w+)"/.match(request.env['HTTP_AUTHORIZATION'])
	      if authorization_matches
	        return authorization_matches[1]
	      end
	    end

	    return false
  	end
end
