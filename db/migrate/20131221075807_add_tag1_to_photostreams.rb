class AddTag1ToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :tag1, :string
  end
end
