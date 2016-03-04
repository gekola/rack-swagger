require "spec_helper"

describe Rack::Swagger::IndexPageServer do
  include Rack::Test::Methods
  include Rack::Swagger::ServerHelpers

  def app
    Rack::Swagger::IndexPageServer.new('api-docs')
  end

  it "serves index.html at docs/" do
    get "/docs/", url: "api-docs"
    expect(last_response.body).to eq(File.read(swagger_dist_path + "/index.html"))
  end

  it "redirects docs => docs/?url=api-docs" do
    get "/docs"
    expect(last_response.status).to eq(302)
    expect(last_response.location).to eq("/docs/?url=api-docs")
  end
end
