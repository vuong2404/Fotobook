class RenameConnectionsToNewTable < ActiveRecord::Migration[7.0]
  def change
    rename_table :connections, :temporary_connections
  end
end
