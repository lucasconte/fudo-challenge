module ResponseUtils
  def self.json_response(status, body)
    [
      status,
      { 'content-type' => 'application/json' },
      [body.to_json]
    ]
  end
end
