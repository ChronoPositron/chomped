class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :original
      t.integer :views, null: false, default: 0
      t.string :delete_token

      t.timestamps null: false
    end
  end
end
