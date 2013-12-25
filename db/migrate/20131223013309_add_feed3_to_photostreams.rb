class AddFeed3ToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :feed3, :string
  end
end
