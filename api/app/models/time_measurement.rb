class TimeMeasurement < ApplicationRecord
    validates :channel_identification, presence: true
    validates :measure_minutes, presence: true
end
