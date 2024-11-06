class CreateBusinessHours < ActiveRecord::Migration[7.1]
  def change
    create_table :business_hours do |t|
      t.references :business, null: false, foreign_key: true
      t.string :day_of_the_week
      t.time :opening_time
      t.time :closing_time
      t.boolean :closed

      t.timestamps
    end
  end
end
