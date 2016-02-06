class User < ActiveRecord::Base
	attr_accessor :password
	has_many :sessions

	validates_presence_of :email
	validates_uniqueness_of :email

	before_save :encrypt_password
	after_save :clear_password

	def User.authenticate(email, password)
		user = self.where(:email => email, :activated => true).first
		if user
			encrypted_password = BCrypt::Engine.hash_secret(password, user.salt)
			if encrypted_password == user.encrypted_password
				return user
			end
		end

		return false
	end

	private

	def encrypt_password
		if password.present?
			self.salt = BCrypt::Engine.generate_salt
			self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
		end
	end

	def clear_password
		self.password = nil
	end
end
