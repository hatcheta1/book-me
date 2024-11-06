class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.references :business, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.integer :duration
      t.integer :price

      t.timestamps
    end
  end
end
