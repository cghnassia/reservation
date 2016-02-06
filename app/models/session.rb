class Session < ActiveRecord::Base
	belongs_to :user
	before_save :generate_token

	def generate_token
		if self.auth_token == nil
			self.auth_token = SecureRandom.base64.tr('+/=', 'Qat')
		end
	end

end
