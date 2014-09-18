require "spec_helper"

describe Rack::Swagger::IndexPageServer do
  include Rack::Test::Methods

  def app
    Rack::Swagger::IndexPageServer.new
  end

  it "serves index.html at /docs/" do
    get "/docs/"
    expect(last_response.body).to eq(File.read(Rack::Swagger::ServerHelpers.swagger_dist_path + "/index.html"))
  end

  it "redirects /docs => /docs/" do
    get "/docs"
    expect(last_response.status).to eq(302)
    expect(last_response.location).to eq("/docs/")
  end
end
