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
        def get_url
            uriString = "https://api.heroku.com/apps/#{heroku_app}/releases"
            uri = URI(uriString)
            puts "URI: #{uri}"

            r = Resources::Request.new(uri)
            req=r.create_get_request_header

            res = Net::HTTP.start(uri.hostname,
                :use_ssl => uri.scheme == 'https'
            ) { |http|
                http.request(req)
            }

            if res.code != "200"
                puts "---ERROR---"
                puts res.code
                puts res.message
            else 
                puts res.body
=begin
                result=JSON.parse(res.body)

                result.each { |i|
                    puts i
                    puts "-------------------------------"
                }
=end
            end
        end
    end
end