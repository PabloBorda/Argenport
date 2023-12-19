class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :lastname
      t.string :address
      t.string :phone
      t.string :mobile
      t.string :pic

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
