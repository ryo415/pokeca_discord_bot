require 'discordrb'
require 'dotenv/load'
require 'json'
require './http_client'

bot = Discordrb::Bot.new(token: ENV['BOT_TOKEN'])
http_client = HttpClient.new
green_color_code = 0x00cc74
blue_color_code = 0x0044cc
red_color_code = 0xcc0000

CARD_URL='https://www.pokemon-card.com/card-search/index.php?keyword=%E3%83%AA%E3%82%B6%E3%83%BC%E3%83%89%E3%83%B3&se_ta=&regulation_sidebar_form=XY&pg=&illust=&sm_and_keyword=&keyword='
DECK_URL='https://www.pokemon-card.com/deck/deck.html?deckID='

bot.register_application_command(:time, 'treat time', server_id: ENV['SERVER_ID']) do |cmd|
    cmd.subcommand(:start, 'start time measurement') do |sub|
        sub.integer('minutes', 'number of minutes to measure, default: 25')
    end
    cmd.subcommand(:end, 'end time measurement')
    cmd.subcommand(:now, 'get current time')
end

bot.register_application_command(:coin, 'treat coin', server_id: ENV['SERVER_ID']) do |cmd|
    cmd.subcommand(:toss, 'toss a coin') do |sub|
        sub.integer('count', 'toss count')
    end
end

bot.register_application_command(:dice, 'treat dice', server_id: ENV['SERVER_ID']) do |cmd|
    cmd.subcommand(:roll, 'roll dice') do |sub|
        sub.integer('count', 'roll count')
    end
end

=begin
bot.register_application_command(:search, 'search something', server_id: ENV['SERVER_ID']) do |cmd|
    cmd.subcommand(:card, 'search card') do |sub|
        sub.string('keyword', 'search keyword', required: true)
    end
    cmd.subcommand(:deck, 'search deck by code') do |sub|
        sub.string('code', 'deck code', required: true)
    end
end

bot.register_application_command(:player, 'treat player', server_id: ENV['SERVER_ID']) do |cmd|
    cmd.subcommand(:list, 'list players')
    cmd.subcommand(:update, 'update own name')
end

bot.register_application_command(:deck, 'treat deck', server_id: ENV['SERVER_ID']) do |cmd|
    cmd.subcommand(:list, 'list decks')
    cmd.subcommand(:random, 'choice a random deck')
    cmd.subcommand(:add, 'add deck') do |sub|
        sub.string('name', 'deck name', required: true)
    end
    cmd.subcommand(:delete, 'delete deck') do |sub|
        sub.string('name', 'deck name', required: true)
    end
end
=end

bot.application_command(:time).subcommand(:start) do |cmd|
    minutes = cmd.options['minutes'] || '25'
    params = { channel_identification: cmd.channel_id.to_s, measure_minutes: minutes.to_i }
    response = JSON.parse(http_client.post('/times', params))
    if response['status_code'] == '409'
        cmd.respond(embeds: [{ color: red_color_code, description: '既に計測中です'}])
        next
    end
    cmd.respond(embeds: [{ color: green_color_code, description: '計測開始'}])
end

bot.application_command(:time).subcommand(:end) do |cmd|
    response = JSON.parse(http_client.delete('/times/' + cmd.channel_id.to_s))
    if response['status_code'] == '400'
        cmd.respond(embeds: [{ color: red_color_code, description: '計測していません'}])
        next
    end
    cmd.respond(embeds: [{ color: green_color_code, description: '計測終了: ' + response['time']}])
end

bot.application_command(:time).subcommand(:now) do |cmd|
    response = JSON.parse(http_client.get('/times/' + cmd.channel_id.to_s))
    if response['status_code'] == '400'
        cmd.respond(embeds: [{ color: red_color_code, description: '計測していません'}])
        next
    end
    cmd.respond(embeds: [{ color: green_color_code, description: '現在の経過時間: ' + response['time']}])
end

bot.application_command(:coin).subcommand(:toss) do |cmd|
    count = 1
    count = cmd.options['count'] if cmd.options['count']
    if count < 1 || count > 10
        cmd.respond(embeds: [{ color: red_color_code, description: 'countは1以上10以下で指定してください'}])
        next
    end
    cmd.respond(embeds: [{ color: green_color_code, description: "コインを#{count}回投げます"}])

    count.times do |count|
        case rand(2)
        when 0 then
            result = "表"
        when 1 then
            result = "裏"
        else
            result = "テーブル外に飛んで行った"
        end
        cmd.send_message(embeds: [{ color: green_color_code, description: result }])
    end
end

bot.application_command(:dice).subcommand(:roll) do |cmd|
    count = 1
    count = cmd.options['count'] if cmd.options['count']
    if count < 1 || count > 10
        cmd.respond(embeds: [{ color: red_color_code, description: 'countは1以上10以下で指定してください'}])
        next
    end
    cmd.respond(embeds: [{ color: green_color_code, description: "ダイスを#{count}回振ります"}])

    count.times do |count|
        cmd.send_message(embeds: [{ color: green_color_code, description: "#{rand(6)+1}"}])
    end
end

=begin
bot.application_command(:search).subcommand(:card) do |cmd|

end

bot.application_command(:search).subcommand(:deck) do |cmd|

bot.application_command(:player).subcommand(:list) do |cmd|
    cmd.respond(content: "プレイヤー一覧")
end

bot.application_command(:player).subcommand(:update) do |cmd|
    cmd.respond(content: "プレイヤー名更新")
end

bot.application_command(:deck).subcommand(:list) do |cmd|
    cmd.respond(content: "デッキ一覧")
end

bot.application_command(:deck).subcommand(:add) do |cmd|
    cmd.respond(content: "デッキ追加 #{cmd.options['name']}")
end

bot.application_command(:deck).subcommand(:delete) do |cmd|
    cmd.respond(content: "デッキ削除 #{cmd.options['name']}")
end

bot.application_command(:deck).subcommand(:random) do |cmd|
    cmd.respond(content: "ランダムデッキ")
end
=end

bot.run