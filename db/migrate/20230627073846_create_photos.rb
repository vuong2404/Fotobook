class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.boolean :sharing_mode
      t.string :description
      t.string :title
      t.binary :image

      t.timestamps
    end
  end
end
