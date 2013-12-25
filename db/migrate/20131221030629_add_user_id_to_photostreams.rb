class AddUserIdToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :user_id, :string
  end
end
