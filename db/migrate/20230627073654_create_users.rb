class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :role
      t.string :password
      t.binary :avatar

      t.timestamps
    end
  end
end
