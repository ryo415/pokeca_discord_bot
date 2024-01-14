namespace :time_check do
    desc "check TimeMeasure time"
    task :run => :environment do
        tms = TimeMeasurement.all
        discord_client = DiscordApiClient.new
        green_color_code = 0x00cc74

        tms.each do |tm|
            minutes = ((Time.now - tm.created_at) / 60).truncate
            # 時間チェック
            if minutes > 0 && minutes % 5 == 0
                text = '分経過'
                if minutes >= tm.measure_minutes
                    text += "\n設定時間を経過したため計測終了します"
                end

                params = {
                    'embed': [{ color: green_color_code , description: minutes.to_s + text}]
                }

                response = discord_client.post('/channels/' + tm.channel_identification + '/messages', params)
            end
            tm.destroy if minutes >= tm.measure_minutes
        end
    end
end
