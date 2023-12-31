class CreateNewConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections, id: false do |t|
      t.references :follower, foreign_key: { to_table: :users }
      t.references :following, foreign_key: { to_table: :users }

      t.timestamps

      t.index [:follower_id, :following_id], unique: true
    end
  end
end