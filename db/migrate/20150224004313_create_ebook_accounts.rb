class CreateEbookAccounts < ActiveRecord::Migration
  def change
    create_table :ebook_accounts do |t|
      t.integer :twitter_id, limit: 5
      t.string  :screen_name

      t.timestamps null: false
    end
  end
end
