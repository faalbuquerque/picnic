class CreateBaskets < ActiveRecord::Migration[7.0]
  def change
    create_table :baskets do |t|
      t.string :name, limit: 50

      t.timestamps
    end
  end
end
