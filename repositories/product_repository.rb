require_relative '../models/product'
require_relative '../utils/type_utils'
require_relative '../dao/product_dao'
require 'redis'
require 'securerandom'
require_relative '../adapter/product_adapter'

class ProductRepository
  include ProductDao

  def initialize(redis_host: 'redis', redis_port: 6379)
    @redis = Redis.new(host: redis_host, port: redis_port)
  end

  def find_all
    keys = @redis.keys('product:*')
    keys.map do |key|
      product_data = @redis.get(key)
      ProductAdapter.from_json(product_data)
    end
  end

  def find_by_id(id)
    key = "product:#{id}"
    product_data = @redis.get(key)
    product_data ? ProductAdapter.from_json(product_data) : nil
  end

  def save(product)
    TypeUtils.validate_type(product, Product)

    existing_product = find_by_id(product.id)
    raise "Product already exists" if existing_product

    @redis.set("product:#{product.id}", ProductAdapter.to_json(product))

    product
  end
end
