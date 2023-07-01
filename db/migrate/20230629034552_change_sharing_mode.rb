class ChangeSharingMode < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      change_table :photos do |t|
        dir.up {t.change :sharing_mode, :string}
        dir.down {t.change :sharing_mode, :boolean}
      end

      change_table :albums do |t|
        dir.up {t.change :sharing_mode, :string}
        dir.down {t.change :sharing_mode, :boolean}
      end
    end
  end
end
