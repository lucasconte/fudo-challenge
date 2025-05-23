require 'json'
require_relative '../utils/type_utils'
require_relative '../models/product'
require_relative '../utils/response_utils'
require_relative '../adapter/product_adapter'


class ProductController
  def initialize(product_service)
    TypeUtils.validate_type(product_service, ProductService)
    @product_service = product_service
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.path == '/products' && request.get?
      find_all(request)
    elsif request.path == '/products' && request.post?
      save(request)
    else
      return nil
    end
  end

  private

  def find_all(request)
    begin
      products = @product_service.find_all.map { |p| ProductAdapter.to_json(p) }
      return ResponseUtils.json_response(200, products)
    end
  end

  def save(request)
    begin
      request_body = JSON.parse(request.body.read)
      product = ProductAdapter.to_model(request_body)
      @product_service.create_product_async(product)

      ResponseUtils.json_response(202, { message: "Product creation scheduled", name: product.name })
    rescue JSON::ParserError
      ResponseUtils.json_response(400, { error: 'Invalid JSON' })
    rescue => e
      ResponseUtils.json_response(400, { error: e.message })
    end
  end
end
