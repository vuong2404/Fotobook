class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.boolean :sharing_mode
      t.string :description
      t.string :title

      t.timestamps
    end
  end
end
