class SessionSerializer < ActiveModel::Serializer
	root 'session'
	attributes :user_id, :auth_token
end
