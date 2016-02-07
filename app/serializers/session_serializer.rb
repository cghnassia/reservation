class SessionSerializer < ActiveModel::Serializer
	attributes :user_id, :auth_token
end
