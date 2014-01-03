class AddUsernameToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :username, :string
  end
end
