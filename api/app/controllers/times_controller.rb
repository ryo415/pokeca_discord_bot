class TimesController < ApplicationController
    def show
        channel_identification = params[:id]
        tm = TimeMeasurement.find_by(channel_identification: channel_identification)
        now = Time.now

        if tm.nil?
            render status: 400, json: { status_code: '400', message: 'data not found', time: '??:??' } and return
        end

        seconds = ((now - tm.created_at) % 60).round
        minutes = ((now - tm.created_at) / 60).truncate

        render status: 200, json: { status_code: '200', message: 'success', time: minutes.to_s + ":" + format("%02d", seconds) }
    end

    def create
        channel_identification = params[:channel_identification]
        tm = TimeMeasurement.find_or_initialize_by(channel_identification: channel_identification)

        if !tm.new_record?
            render status: 409, json: { status_code: '409', message: 'already being measured' } and return
        end

        tm.measure_minutes = params[:measure_minutes].to_i

        if tm.save
            render status: 200, json: { status_code: '200', message: 'success', time: '00:00' }
        else
            render status: 500, json: { status_code: '500', message: 'create error', time: '00:00' }
        end
    end

    def destroy
        channel_identification = params[:id]
        tm = TimeMeasurement.find_by(channel_identification: channel_identification)

        if tm.nil?
            render status: 400, json: { status_code: '400', message: 'data not found', time: '??:??' } and return
        end

        seconds = ((Time.now - tm.created_at) % 60).round
        minutes = ((Time.now - tm.created_at) / 60).round

        if tm.destroy
            render status: 200, json: { status_code: '200', message: 'success', time: minutes.to_s + ':' + seconds.to_s } and return
        else
            render status: 500, json: { status_code: '500', message: 'destroy error', time: minutes.to_s + ':' + seconds.to_s } and return
        end
    end
end
