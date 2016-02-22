module ApiHelpers
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def json response
    JSON.parse(response.body)
  end

  def status response
    response.status
  end

  def login_as user
    token_headers = user.create_new_auth_token

    token_headers.each do |key, value|
      header key, value
    end
  end
end
