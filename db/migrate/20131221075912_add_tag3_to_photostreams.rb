class AddTag3ToPhotostreams < ActiveRecord::Migration
  def change
    add_column :photostreams, :tag3, :string
  end
end
