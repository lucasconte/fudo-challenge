require 'sidekiq/web'
require './app'
require './middleware/auth_middleware'
require 'rack/deflater'
require 'rack/cors'

run Rack::Builder.new {
  
  use Rack::Cors do
    allow do
      origins '*'  # For more security, origins should be specified
      resource '/docs/openapi.yaml', headers: :any, methods: [:get]
      resource '/products', headers: :any, methods: [:get, :post]
      resource '/login', headers: :any, methods: [:post]
      resource '/register', headers: :any, methods: [:post]
    end
  end

  map '/sidekiq' do
    run Sidekiq::Web
  end
  
  map '/' do
    use Rack::Deflater # compression middleware
    use AuthMiddleware, AUTH_SERVICE # authentication middleware

    run lambda { |env|
      response = LOGIN_CONTROLLER.call(env)
      response ||= PRODUCT_CONTROLLER.call(env)
      response || [404, { 'content-type' => 'application/json' }, ['{"error": "Not Found"}']]
    }
  end

  map '/docs/openapi.yaml' do
    run lambda { |env|
      [
        200,
        {
          'content-type' => 'text/yaml',
          'cache-control' => 'no-store, no-cache, must-revalidate, proxy-revalidate',
          'pragma' => 'no-cache',
          'expires' => '0'
        },
        [File.read(File.expand_path('../docs/openapi.yaml', __dir__))]
      ]
    }
  end

  map '/AUTHORS' do
    run lambda { |env|
      [
        200,
        {
          'content-type' => 'text/plain',
          'cache-control' => 'public, max-age=86400' # 24hs
        },
        [File.read(File.expand_path('AUTHORS', __dir__))]
      ]
    }
  end
}
