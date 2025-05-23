require 'jwt'
require_relative '../services/token_service'

class JwtService
  include TokenService

  # This should be a secret environment variable
  SECRET_KEY = 'your_secret_key'
  EXPIRATION_TIME = 3600
  ALGORITHM = 'HS256'

  def generate_token(user)
    payload = {
      user: user.name,
      exp: Time.now.to_i + EXPIRATION_TIME
    }
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def decode_token(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM)
    decoded[0]
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end
end
