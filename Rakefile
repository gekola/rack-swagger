require "bundler/gem_tasks"
require 'yaml'
require 'httpclient'
require 'json'

task default: [:swagger_ui]

desc "Update swagger-ui distribution files if they have changed."
task swagger_ui: ["swagger-ui", :update_swagger_ui]

directory "swagger-ui"

task :update_swagger_ui do
  client = HTTPClient.new
  res = client.get('https://codeload.github.com/wordnik/swagger-ui/legacy.tar.gz/master', follow_redirect: true)
  raise "Github API returned #{res.inspect}" if res.status != 200

  # pull down swagger-ui mainline
  cd "swagger-ui"
  tar = res.content
  File.open("master.tar.gz", "w+") { |f| f << tar }
  sh("tar xvf master.tar.gz --include '*swagger-ui*/dist*' --strip-components 1")
  cd ".."

  # apply branding
  puts `cat lib/rack/swagger/rentpath/rentpath.diff | patch -p1`
  cp "lib/rack/swagger/rentpath/logo_small.png", "swagger-ui/dist/images/logo_small.png"

  # replace petstore with real docs
  index_page = File.read("swagger-ui/dist/index.html")
  File.open("swagger-ui/dist/index.html", "w+") { |f| f << index_page.gsub("http://petstore.swagger.wordnik.com/api/api-docs", "api-docs") }
end
