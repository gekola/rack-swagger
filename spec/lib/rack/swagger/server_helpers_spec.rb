require "spec_helper"

describe Rack::Swagger::ServerHelpers do
  include Rack::Swagger::ServerHelpers

  describe "display_file_or_404" do
    it "404 if file does not exist" do
      result = display_file_or_404(:json, "blah.json")
      expect(result[0]).to eq(404)
    end

    it "404 if file does not exist" do
      result = display_file_or_404(:html, "blah.html")
      expect(result[0]).to eq(404)
    end

    it "serves file if file does exist" do
      result = display_file_or_404(:html, __FILE__)
      expect(result[0]).to eq(200)
      expect(result[2].read).to eq(File.read(__FILE__))
    end

    it "serves proper json content type for :json" do
      result = display_file_or_404(:json, __FILE__)
      expect(result[1]["Content-Type"]).to eq("application/json")
    end

    it "escapes relevant ENV vars" do
      ENV["SWAGGER_TEST"] = "foo"
      myvar = "ENV[SWAGGER_TEST]"

      result = display_file_or_404(:json, __FILE__)
      str = result[2].read
      expect(str).not_to include('myvar = "ENV[SWAGGER_TEST]"')
      expect(str).to include('myvar = "foo"')
    end
  end
end
