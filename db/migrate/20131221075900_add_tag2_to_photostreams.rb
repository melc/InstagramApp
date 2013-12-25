class AddTag2ToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :tag2, :string
  end
end
