# Rack::Swagger

Serve up Swagger UI and docs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-swagger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-swagger

## Usage

Set up a docs folder in your project. Place the root API doc there and call it
"swagger.json". Place your resource API docs there as well. For example, if you
have one resource called "pet", your docs folder will have two files:

* swagger.json (the root API doc)
* pet.json (the pet resource)

In your config.ru, run Rack::Swagger.app(), passing in the path to your docs
folder.

```ruby
run Rack::Swagger.app(File.expand_path("../docs/", __FILE__))
```

This will serve the swagger-ui front-end at **/docs/**, and your
doc files at **/docs/api-docs/**. 

Your resource definitions should look ike this:

```json
  {
    "path": "/pet",
    "description": "Operations about pets"
  },
```

## Getting basePath right

##### Using overwrite_base_path

If you are seeing a lot of 404s or CORS-related errors in your docs, you may
need to tweak the basePath.

You always need to have the basePath point to the same hostname as your API. If
you have multiple deploys of your application under different hostnames, and
they share the same set of JSON files, you can use the overwrite_base_path
option in Rack::Swagger.app() to vary this dynamically.

For example, say you have an environment variable called MY_API_HOST, which
contains the hostname of your app for a given deployment:

```ruby
  Rack::Swagger.app(
    File.expand_path("../docs/", __FILE__),
    overwrite_base_path: ENV["MY_API_HOST"]
  )
```

##### Setting basePath manually

If you're not using overwrite_base_path, rack-swagger will just use your
basePath value from your JSON files. But just know that basePath will have
different values depending on the file:

* For the resource files, it should point to the API root path.
* For the root file, it should point to the API root path, plus "/docs/api-docs".

## Upgrading swagger-ui

A distribution of swagger-ui is included with rack-swagger. For developers who
want to upgrade this distribution, there is a Rake task which pulls down the
latest version and applies some changes to it. To use, run:

```
rake swagger_ui
```

If someone downloads the distribution without using the Rake task and you're
trying to restore back to the original, remove the directory and version
file before running the rake task:

```
rm -rf swagger-ui/
rm swagger_ui_version.yml
rake swagger_ui
```

Then check in the updated code.

## Notes

For an example of properly formatted Swagger 1.2 JSON files working together
with [swagger-ui](https://github.com/wordnik/swagger-ui), see:
[http://petstore.swagger.wordnik.com/](Pet Store Demo).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack-swagger/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

