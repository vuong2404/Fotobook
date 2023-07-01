class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|

      t.timestamps
    end
  end
end
