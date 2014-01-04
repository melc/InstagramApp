class AddRrUserIdToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :rr_user_id, :string
  end
end
