class AddAlbumIdToPhotos < ActiveRecord::Migration[7.0]
  def change
    add_reference :photos, :album, null: true, on_delete: :cascade, foreign_key: true
  end
end
