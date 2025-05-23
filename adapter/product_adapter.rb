require_relative '../models/product' 

class ProductAdapter
  def self.to_model(request)
    id = request['id']
    name = request['name']

    raise ArgumentError, 'Product ID is required' if id.nil?
    raise ArgumentError, 'Product name is required' if name.nil?

    unless id.is_a?(Integer) && id > 0
      raise ArgumentError, 'Product ID must be an integer greater than 0'
    end
    
    unless name.is_a?(String) && !name.strip.empty?
      raise ArgumentError, 'Product name must be a non-empty string'
    end

    Product.new(id, name)
  end

  def self.to_json(product)
    { id: product.id, name: product.name }.to_json
  end

  def self.from_json(json_str)
    data = JSON.parse(json_str)
    Product.new(data['id'], data['name'])
  end
end
