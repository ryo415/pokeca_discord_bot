require 'net/http'
require 'dotenv/load'

class HttpClient
    def initialize
        @api_base = ENV['API_URL']
    end

    def get(path)
        url = @api_base + path
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)

        headers = { "Content-Type" => "application/json" }
        response = http.get(uri.path, headers)

        response.body
    end

    def post(path, params)
        url = @api_base + path
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)

        headers = { "Content-Type" => "application/json" }
        response = http.post(uri.path, params.to_json, headers)

        response.body
    end

    def delete(path)
        url = @api_base + path
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)

        headers = { "Content-Type" => "application/json" }
        response = http.delete(uri.path, headers)

        response.body
    end
end