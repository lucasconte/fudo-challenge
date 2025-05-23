class UserAdapter
  def self.toModel(request)
    name = request['user']
    password = request['password']

    raise ArgumentError, 'User name is required' if name.nil?
    raise ArgumentError, 'User password is required' if password.nil?

    unless name.is_a?(String) && !name.strip.empty?
      raise ArgumentError, 'User name must be a non-empty string'
    end

    unless password.is_a?(String) && !password.strip.empty?
      raise ArgumentError, 'User password must be a non-empty string'
    end

    return User.new(name, password)
  end
end
