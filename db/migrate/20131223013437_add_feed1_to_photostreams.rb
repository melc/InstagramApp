class AddFeed1ToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :feed1, :string
  end
end
