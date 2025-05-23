require 'json'
require_relative '../utils/type_utils'
require_relative '../services/authentication_service'

class AuthMiddleware
  PROTECTED_PATHS = ['/products']

  def initialize(app, auth_service)
    TypeUtils.validate_type(auth_service, AuthenticationService)
    @app = app
    @auth_service = auth_service
  end

  def call(env)
    request = Rack::Request.new(env)

    if PROTECTED_PATHS.any? { |path| request.path.start_with?(path) }
      auth_header = request.get_header("HTTP_AUTHORIZATION")
      
      unless auth_header&.start_with?("Bearer ")
        return unauthorized("Missing or invalid Authorization header")
      end

      token = auth_header.split.last
      user = @auth_service.authenticate_with_token(token)

      return unauthorized("Invalid token") unless user

      env['authenticated_user'] = user
    end

    @app.call(env)
  end

  private

  def unauthorized(message)
    [401, { 'content-type' => 'application/json' }, [{ error: message }.to_json]]
  end
end
