module UserDao
  def find_by_name(name)
    raise NotImplementedError, "#{self.class} implement find_by_name(name)"
  end

  def save(user)
    raise NotImplementedError, "#{self.class} implement save(user)"
  end
end
