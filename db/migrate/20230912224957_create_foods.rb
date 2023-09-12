class CreateFoods < ActiveRecord::Migration[7.0]
  def change
    create_table :foods do |t|
      t.string :name, limit: 50
      t.references :basket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
