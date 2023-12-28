namespace :time_check do
    desc "check TimeMeasure time"
    task :run => :environment do
        tms = TimeMeasurement.all
        discord_client = DiscordApiClient.new

        tms.each do |tm|
            minutes = ((Time.now - tm.created_at) / 60).truncate
            # 時間チェック
            if minutes % 5 == 0
                text = '分経過'
                if minutes >= tm.measure_minutes
                    text += "\n設定時間を経過したため計測終了します"
                end

                params = {
                    'content': minutes.to_s + text
                }

                response = discord_client.post('/channels/' + tm.channel_identification + '/messages', params)
                tm.destroy if minutes >= tm.measure_minutes
            end
        end
    end
end
