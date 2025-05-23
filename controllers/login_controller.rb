require 'json'
require_relative '../utils/response_utils'
require_relative '../utils/type_utils'
require_relative '../adapter/user_adapter'

class LoginController
  def initialize(authentication_service)
    TypeUtils.validate_type(authentication_service, AuthenticationService)
    @authentication_service = authentication_service
  end

  def call(env)
    request = Rack::Request.new(env)
    
    if request.path == '/login' && request.post?
      authenticate(request)
    elsif request.path == '/register' && request.post?
      register(request)
    else
      return nil
    end
  end

  private

  def authenticate(request)
    begin
      request_body = JSON.parse(request.body.read)
      user = UserAdapter.toModel(request_body);
      token = @authentication_service.authenticate(user)

      if token
        ResponseUtils.json_response(200, { message: 'Authentication successful', token: token })
      else
        ResponseUtils.json_response(401, { error: 'Invalid credentials' })
      end
    rescue JSON::ParserError
      ResponseUtils.json_response(400, { error: 'Invalid JSON' })
    end
  end

  def register(request)
    begin
      request_body = JSON.parse(request.body.read)
      user = UserAdapter.toModel(request_body);
      @authentication_service.register(user)

      ResponseUtils.json_response(201, { message: 'User registered successfully' })
    rescue JSON::ParserError
      ResponseUtils.json_response(400, { error: 'Invalid JSON' })
    rescue => e
      ResponseUtils.json_response(400, { error: e.message })
    end
  end

end

