require 'sidekiq'
require_relative '../models/product'
require_relative '../repositories/product_repository'
require_relative '../adapter/product_adapter'

class CreateProductWorker
  include Sidekiq::Worker

  def perform(product_json)
    product = ProductAdapter.from_json(product_json)
    product_repo = ProductRepository.new
    begin
      saved_product = product_repo.save(product)
      puts "Producto '#{saved_product.name}' creado exitosamente."
    rescue => e
      puts "Error al crear producto: #{e.message}"
    end
  end
end
