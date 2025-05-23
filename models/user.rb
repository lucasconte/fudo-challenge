class User
  attr_accessor :name, :password_hash

  def initialize(name, password_hash)
    @name = name
    @password_hash = password_hash
  end
end
