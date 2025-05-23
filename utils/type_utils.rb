class TypeUtils
  def self.validate_type(object, expected_type)
    unless object.is_a?(expected_type)
      raise TypeError, "Expected #{expected_type}, but got #{object.class}"
    end
  end
end
