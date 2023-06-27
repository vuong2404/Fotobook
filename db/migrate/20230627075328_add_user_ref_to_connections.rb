class AddUserRefToConnections < ActiveRecord::Migration[7.0]
  def change
    add_reference :connections, :follower, null: false, foreign_key:  {to_table: :users}
    add_reference :connections, :following, null: false, foreign_key:  {to_table: :users}
  end
end
