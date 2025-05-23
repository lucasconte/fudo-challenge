module TokenService
  def generate_token(user)
    raise NotImplementedError, "#{self.class} must implement the generate_token(user)"
  end

  def decode_token(token)
    raise NotImplementedError, "#{self.class} must implement the decode_token(token)"
  end
end
