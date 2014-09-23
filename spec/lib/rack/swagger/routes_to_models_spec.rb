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

  let(:expected_result_2) {{
    "AdMobBannerIds"=>
      {:id=>"AdMobBannerIds",
       :properties=>
        {"AGBannerResultsListTelCoAdUnitId"=>{:type=>"string"},
         "AGBannerResultsListAdUnitId"=>{:type=>"string"},
         "AGBannerDetailsAdUnitId"=>{:type=>"string"},
         "AGBannerDetailsTelCoAdUnitId_1"=>{:type=>"string"},
         "AGBannerDetailsTelCoAdUnitId_2"=>{:type=>"string"},
         "AGBannerThankYouAdUnitId"=>{:type=>"string"},
         "AGBannerThankYouTelCoAdUnitId"=>{:type=>"string"}}},
    "Config"=>
      {:id=>"Config",
       :properties=>
        {"copyright"=>{:type=>"string"},
         "offsiteAnalyticsFlag"=>{:type=>"string"},
         "offsiteAnalyticsQueueLimit"=>{:type=>"string"},
         "adMobBannerIds"=>{"$ref"=>"AdMobBannerIds"}
        }
      }
  }}

  let(:sample_response_2) {{
    "copyright"=>
      "Copyright 2014 RentPath, Inc.  All rights reserved.  All photos, videos, text and other content are the property of RentPath, Inc.  APARTMENT GUIDE and the APARTMENT GUIDE Trade Dress are registered trademarks of RentPath, Inc. or its affiliates.",
      "offsiteAnalyticsFlag"=>"true",
      "offsiteAnalyticsQueueLimit"=>"50",
      "adMobBannerIds"=>
        {"AGBannerResultsListTelCoAdUnitId"=>
         "/7449/mob.aptguide.com.%@/Search/tlp_p",
         "AGBannerResultsListAdUnitId"=>"/7449/mob.aptguide.com.%@/Search/b_lb_p1",
         "AGBannerDetailsAdUnitId"=>"/7449/mob.aptguide.com.%@/Detail/b_lb_p1",
         "AGBannerDetailsTelCoAdUnitId_1"=>"/7449/mob.aptguide.com.%@/Detail/tdp_p1",
         "AGBannerDetailsTelCoAdUnitId_2"=>"/7449/mob.aptguide.com.%@/Detail/tdp_p2",
         "AGBannerThankYouAdUnitId"=>"/7449/mob.aptguide.com.%@/ThankYou/b_lb_p1",
         "AGBannerThankYouTelCoAdUnitId"=>"/7449/mob.aptguide.com.%@/ThankYou/tdp_p1"
        }
  }}

  it "turns a response into a model declaration" do
    expect(generate_models(sample_response, "Pins")).to eq expected_result
  end

  it "turns another response into a model declaration" do
    expect(generate_models(sample_response_2, "Config")).to eq expected_result_2
  end
end
