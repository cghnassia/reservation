class CreateSessions < ActiveRecord::Migration
  def up
    create_table :sessions do |t|
      t.integer :user_id, :null => false
      t.string :auth_token, :null => false
      t.timestamps null: false
    end
  end

  def down
  	drop_table :sessions
  end
end
