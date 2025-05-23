require 'sidekiq'
require_relative './controllers/login_controller'
require_relative './repositories/user_repository'
require_relative './services/authentication_service'
require_relative './services/jwt_service'

require_relative './repositories/product_repository'
require_relative './services/product_service'
require_relative './controllers/product_controller'

# Login setup
user_dao = UserRepository.new
token_service = JwtService.new
auth_service = AuthenticationService.new(user_dao, token_service)

LOGIN_CONTROLLER = LoginController.new(auth_service)

# Product setup
product_dao = ProductRepository.new
product_service = ProductService.new(product_dao)
PRODUCT_CONTROLLER = ProductController.new(product_service)


# Sidekiq setup

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

# Middleware setup

AUTH_SERVICE = auth_service