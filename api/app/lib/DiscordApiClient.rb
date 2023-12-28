require 'net/http'

class DiscordApiClient
    def initialize
        @base_url = 'https://discord.com/api'
        @bot_token = ENV['BOT_TOKEN']
    end

    def get(path)
        url = @base_url + path
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme === "https"

        headers = {
            "Authorization" => "Bot " + @bot_token,
            "Content-Type" => "application/json"
        }
        response = http.get(uri.path, headers)

        response.body
    end

    def post(path, params)
        url = @base_url + path
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme === "https"

        headers = {
            "Authorization" => "Bot " + @bot_token,
            "Content-Type" => "application/json"
        }
        response = http.post(uri.path, params.to_json, headers)

        response.body
    end
end