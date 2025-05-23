require_relative '../models/user'
require_relative '../dao/user_dao'
require_relative '../utils/type_utils'

class UserRepository
  include UserDao

  def initialize
    @users = []
  end

  def find_by_name(name)
    @users.find { |user| user.name == name }
  end

  def save(user)
    TypeUtils.validate_type(user, User)
    raise "User already exists" if find_by_name(user.name)

    @users << user
    user
  end
end
