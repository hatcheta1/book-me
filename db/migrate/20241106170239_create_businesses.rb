class CreateBusinesses < ActiveRecord::Migration[7.1]
  def change
    create_table :businesses do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name
      t.string :address
      t.string :about

      t.timestamps
    end
  end
end
