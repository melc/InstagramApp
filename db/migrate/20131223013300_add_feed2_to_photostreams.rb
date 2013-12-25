class AddFeed2ToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :feed2, :string
  end
end
