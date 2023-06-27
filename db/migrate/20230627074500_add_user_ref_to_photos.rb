class AddUserRefToPhotos < ActiveRecord::Migration[7.0]
  def change
    add_reference :photos, :user, null: false, foreign_key: true
  end
end
