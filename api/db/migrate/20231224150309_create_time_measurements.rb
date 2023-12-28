class CreateTimeMeasurements < ActiveRecord::Migration[7.1]
  def change
    create_table :time_measurements do |t|
      t.string :channel_identification, null: false
      t.integer :measure_minutes, null: false

      t.timestamps
    end
  end
end
