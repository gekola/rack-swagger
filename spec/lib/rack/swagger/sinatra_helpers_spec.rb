require 'spec_helper'

class MockSinatraApp
  attr_accessor :routes
end

describe Rack::Swagger::SinatraHelpers do
  before do
    # removed the Procs from the Sinatra::Base.routes output because
    # we don't need it (replaced with nil)
    app1routes = {
      "GET"=>[[/\A\/config\z/, [], [], nil],
             [/\A\/listings\/?\z/, [], [], nil],
             [/\A\/show\/?([^\/?#]+)?\/?\z/, ["id"], [], nil],
             [/\A\/diamondmax\/?\z/, [], [], nil],
             [/\A\/map\/pins(?:\.|%2[Ee])json\z/, [], [], nil],
             [/\A\/map\/pin\/([^\/?#]+)\/?\z/, ["id"], [], nil],
             [/\A\/refinementlist\/?\z/, [], [], nil],
             [/\A\/reviews\/([^\/?#]+)\/?\z/, ["id"], [], nil],
             [/\A\/listings\/search\/?\z/, [], [], nil],
             [/\A\/search\/?\z/, [], [], nil],
             [/\A\/telcos\z/, [], [], nil],
             [/\A\/([^\/?#]+)\/states\/?\z/, ["channel"], [], nil],
             [/\A\/([^\/?#]+)\/([^\/?#]+)\/cities\/?\z/, ["channel", "state"], [], nil],
             [/\A\/mgtco\/([^\/?#]+)\/([^\/?#]+)\/([^\/?#]+)\/?\z/, ["state", "city", "mgtcoid"], [], nil],
             [/\A\/listings\/([^\/?#]+)\/recommendations\/?\z/, ["id"], [], nil],
             [/\A\/protobuf_test\z/, [], [], nil],
             [/\A\/rent\/listings\/?\z/, [], [], nil]

    ], "HEAD"=>[[/\A\/config\z/, [], [], nil],
                [/\A\/listings\/?\z/, [], [], nil],
                [/\A\/show\/?([^\/?#]+)?\/?\z/, ["id"], [], nil],
                [/\A\/diamondmax\/?\z/, [], [], nil],
                [/\A\/map\/pins(?:\.|%2[Ee])json\z/, [], [], nil],
                [/\A\/map\/pin\/([^\/?#]+)\/?\z/, ["id"], [], nil],
                [/\A\/refinementlist\/?\z/, [], [], nil],
                [/\A\/reviews\/([^\/?#]+)\/?\z/, ["id"], [], nil],
                [/\A\/listings\/search\/?\z/, [], [], nil],
                [/\A\/search\/?\z/, [], [], nil],
                [/\A\/telcos\z/, [], [], nil],
                [/\A\/([^\/?#]+)\/states\/?\z/, ["channel"], [], nil],
                [/\A\/([^\/?#]+)\/([^\/?#]+)\/cities\/?\z/, ["channel", "state"], [], nil],
                [/\A\/mgtco\/([^\/?#]+)\/([^\/?#]+)\/([^\/?#]+)\/?\z/, ["state", "city", "mgtcoid"], [], nil],
                [/\A\/listings\/([^\/?#]+)\/recommendations\/?\z/, ["id"], [], nil],
                [/\A\/protobuf_test\z/, [], [], nil],
                [/\A\/rent\/listings\/?\z/, [], [], nil]
    ]}

    app2routes = {
      "GET"=>[[/\A\/reviews\/([^\/?#]+)\/?\z/, ["id"], [], nil],
              [/\A\/reviews\/partial\/([^\/?#]+)\z/, ["id"], [], nil]],

      "HEAD"=>[[/\A\/reviews\/([^\/?#]+)\/?\z/, ["id"], [], nil],
               [/\A\/reviews\/partial\/([^\/?#]+)\z/, ["id"], [], nil]],

      "POST"=>[[/\A\/reviews\/flag\/([^\/?#]+)\/([^\/?#]+)\/([^\/?#]+)\z/, ["id", "type", "review_id"], [], nil]]
    }

    @app1 = MockSinatraApp.new
    @app1.routes = app1routes
    @app2 = MockSinatraApp.new
    @app2.routes = app2routes
  end

  it "extracts the API routes from the Sinatra::Base.routes" do

    expected_result = {"GET"=>["/config", "/listings", "/show", "/show/{id}", "/diamondmax",
                               "/map/pins.json", "/map/pin/{id}", "/refinementlist", "/reviews/{id}",
                               "/listings/search", "/search", "/telcos", "/{channel}/states",
                               "/{channel}/{state}/cities", "/mgtco/{state}/{city}/{mgtcoid}",
                               "/listings/{id}/recommendations", "/protobuf_test", "/rent/listings",
                               "/reviews/{id}", "/reviews/partial/{id}"],

                       "HEAD"=>["/config", "/listings", "/show", "/show/{id}", "/diamondmax",
                                "/map/pins.json", "/map/pin/{id}", "/refinementlist", "/reviews/{id}",
                                "/listings/search", "/search", "/telcos", "/{channel}/states",
                                "/{channel}/{state}/cities", "/mgtco/{state}/{city}/{mgtcoid}",
                                "/listings/{id}/recommendations", "/protobuf_test", "/rent/listings",
                                "/reviews/{id}", "/reviews/partial/{id}"],

                       "POST"=>["/reviews/flag/{id}/{type}/{review_id}"]}

    expect(Rack::Swagger::SinatraHelpers.get_all_routes(@app1, @app2)).to eq(expected_result)
  end
end
