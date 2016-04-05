require "heroku-slug/version"
require "heroku-slug/res/request"

require "net/http"
require "json"
require "thor"

module HerokuSlug
    
    ##include Resoures
    puts "Heroku Slug URL"
    puts "Version #{VERSION}"

    class HerokuSlug < Thor

        desc "get-url", "gets slug url from heroku"
        option :heroku_app, :type => :string, :required => true
        #option :user, :type => :string, :required => true
        #option :pass, :type => :string, :required => true
        def get_url
            heroku_app = options[:heroku_app]
            uriString = "https://api.heroku.com/apps/#{heroku_app}/releases"
            accept = '"Accept: application/vnd.heroku+json; version=3"'
            uri = URI(uriString)
            puts "URI: #{uri}"

            res = `curl -n --silent #{uriString} -H #{accept}`

            result = JSON.parse(res)

            id = nil
            ver = nil
            hash = nil
            result.each { |i|
                #puts i
                if i["slug"] && i["slug"]["id"] && i["slug"]["id"] != ""
                    id = i["slug"]["id"]
                    ver = i["version"]
                    hash = i["description"]
                end
            }

            #puts id if id
            if id != nil

                uriStringSlug = "https://api.heroku.com/apps/#{heroku_app}/slugs/#{id}"
                uriSlug = URI(uriStringSlug)

                resSlug = `curl -n --silent #{uriStringSlug} -H #{accept}`
                resultSlug = JSON.parse(resSlug)
                p "--------------------------------"
                p "Version: #{ver}"
                p "Hash: #{hash}"
                p resultSlug["blob"]["url"]
                p "--------------------------------"
            end
        end
    end
end