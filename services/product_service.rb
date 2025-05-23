require_relative '../utils/type_utils'
require_relative '../models/product'
require_relative '../workers/create_product_worker'
require_relative '../adapter/product_adapter'

class ProductService
  # In seconds
  CREATE_PRODUCT_DELAY_TIME = 5

  def initialize(product_dao)
    TypeUtils.validate_type(product_dao, ProductDao)
    @product_dao = product_dao
  end

  def create_product_async(product)
    TypeUtils.validate_type(product, Product)
    
    existing_product = @product_dao.find_by_id(product.id)
    raise "Product already exists" if existing_product
    CreateProductWorker.perform_in(CREATE_PRODUCT_DELAY_TIME, ProductAdapter.to_json(product))
  end

  def find_all()
    @product_dao.find_all()
  end
end
