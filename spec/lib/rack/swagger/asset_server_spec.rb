require "spec_helper"

describe Rack::Swagger::AssetServer do
  include Rack::Test::Methods
  include Rack::Swagger::ServerHelpers

  def app
    Rack::Swagger::AssetServer.new
  end

  it "serves files from swagger-ui" do
    first_file = Dir.glob(swagger_dist_path + "/css/*").first
    first_file.gsub!(swagger_dist_path, "")

    get "/docs" + first_file
    expect(last_response.body).to eq(File.read(swagger_dist_path + first_file))
  end
end
