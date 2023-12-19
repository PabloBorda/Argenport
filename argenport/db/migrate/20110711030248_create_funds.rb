class CreateFunds < ActiveRecord::Migration
  def self.up
    create_table :funds do |t|
      t.string :account
      t.integer :users_id
      t.float :balance

      t.timestamps
    end
  end

  def self.down
    drop_table :funds
  end
end
