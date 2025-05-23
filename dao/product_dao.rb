module ProductDao
  def find_all()
    raise NotImplementedError, "#{self.class} must implement find_all()"
  end

  def find_by_id(id)
    raise NotImplementedError, "#{self.class} must implement find_by_id(id)"
  end

  def save(product)
    raise NotImplementedError, "#{self.class} must implement save(product)"
  end
end
