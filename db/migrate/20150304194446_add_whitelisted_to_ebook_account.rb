class AddWhitelistedToEbookAccount < ActiveRecord::Migration
  def change
    add_column :ebook_accounts, :whitelisted, :boolean, default: false
  end
end
