require 'spec_helper'

describe Rack::Swagger::RoutesToModels do
  include Rack::Swagger::RoutesToModels

  let(:expected_result) {{
    "Listing" =>
    {id:"Listing", properties:
     {id:{type:"string"}, lat:{type:"number", format:"float"},
      lng:{type:"number", format:"float"}, free:{type:"boolean",
                                                 format:"boolean"}
    }
    },
    "Pins" => 
    {id:"Pins", properties:
     {total:
      {type:"integer", format:"int64"},
      listings:{type:"array", items:{"$ref"=>"Listing"}}
    }
    }
  }}

  let(:sample_response) {{
    total:6,
    listings:[
      {id:"2395", lat:33.9482, lng:-84.261, free:false},
      {id:"111", lat:33.9465, lng:-84.2262, free:false},
      {id:"11413", lat:33.9444, lng:-84.2455, free:false},
      {id:"83798", lat:33.9512, lng:-84.2451, free:false},
      {id:"16993", lat:33.9696, lng:-84.2046, free:false},
      {id:"16020", lat:33.9072, lng:-84.196, free:false}
    ]
  }}

  it "turns a response into a model declaration" do
    expect(generate_models(sample_response, "Pins")).to eq expected_result
  end
end
