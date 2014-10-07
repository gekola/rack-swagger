require "bundler/gem_tasks"
require 'yaml'
require 'httpclient'
require 'json'

task default: [:swagger_ui]

desc "Update swagger-ui distribution files if they have changed."
task swagger_ui: ["swagger-ui", "swagger_ui_version.yml", :check_swagger_ui_version, :update_swagger_ui]

directory "swagger-ui"

file "swagger_ui_version.yml" do
  cp "templates/swagger_ui_version.yml", "swagger_ui_version.yml"
end

def load_swagger_ui_version_yml
  YAML.load(File.read("swagger_ui_version.yml"))
end

def save_swagger_ui_version_yml(yml)
  File.open("swagger_ui_version.yml", "w+") { |f| f << YAML.dump(yml) }
end

task :check_swagger_ui_version do
  client = HTTPClient.new
  res = client.get('https://api.github.com/repos/wordnik/swagger-ui/releases', follow_redirect: true)
  raise "Github API returned #{res.inspect}" if res.status != 200

  json = JSON.parse(res.content)
  latest_release = json[0]["name"]

  raise "could not get latest_release" unless latest_release

  yml = load_swagger_ui_version_yml
  yml[:versions][:theirs] = latest_release
  save_swagger_ui_version_yml(yml)
end

task :update_swagger_ui do
  yml = load_swagger_ui_version_yml

  if yml[:versions][:ours] != yml[:versions][:theirs]
    client = HTTPClient.new
    res = client.get('https://api.github.com/repos/wordnik/swagger-ui/tarball/' + yml[:versions][:theirs], follow_redirect: true)
    raise "Github API returned #{res.inspect}" if res.status != 200

    # pull down swagger-ui mainline
    cd "swagger-ui"
    tar = res.content
    File.open("swagger-ui-#{yml[:versions][:theirs]}.tar", "w+") { |f| f << tar }
    sh("tar xvf swagger-ui-#{yml[:versions][:theirs]}.tar --include '*swagger-ui*/dist*' --strip-components 1")
    cd ".."

    # apply branding
    puts `cat lib/rack/swagger/rentpath/rentpath.diff | patch -p1`
    cp "lib/rack/swagger/rentpath/logo_small.png", "swagger-ui/dist/images/logo_small.png"

    # replace petstore with real docs
    index_page = File.read("swagger-ui/dist/index.html")
    File.open("swagger-ui/dist/index.html", "w+") { |f| f << index_page.gsub("http://petstore.swagger.wordnik.com/api/api-docs", "api-docs") }

    yml[:versions][:ours] = yml[:versions][:theirs]
    save_swagger_ui_version_yml(yml)
  else

    puts "versions match, nothing to do"
  end

  File.open("swagger_ui_version.yml", "w+") { |f| f << YAML.dump(yml) }
end
