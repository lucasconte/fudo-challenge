require_relative '../utils/type_utils'
require_relative '../models/user'
require 'bcrypt'

class AuthenticationService
  def initialize(user_dao, token_service)
    TypeUtils.validate_type(user_dao, UserDao)
    TypeUtils.validate_type(token_service, TokenService)
    @user_dao = user_dao
    @token_service = token_service
  end

  def register(user)
    TypeUtils.validate_type(user, User)
    user.password_hash = BCrypt::Password.create(user.password_hash)
    @user_dao.save(user)
  end

  def authenticate(user)
    TypeUtils.validate_type(user, User)

    found_user = @user_dao.find_by_name(user.name)
    return nil unless found_user
    return @token_service.generate_token(found_user) if BCrypt::Password.new(found_user.password_hash) == user.password_hash

    nil
  end

  def authenticate_with_token(token)
    payload = @token_service.decode_token(token)
    return nil unless payload

    @user_dao.find_by_name(payload['user'])
  end
end
