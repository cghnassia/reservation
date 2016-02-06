class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :middle_name
      t.date :birthdate
      t.string :email, :null => false
      t.string :encrypted_password
      t.string :avatar
      t.string :salt
      t.string :api_token
      t.boolean :activated, :null => false, :default => false
      t.timestamps null: false
    end
  end

  def down
  	drop_table :users
  end
end
