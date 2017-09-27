class CreatePhotostreams < ActiveRecord::Migration
  def change
    create_table :photostreams do |t|
      t.references :user, index: true
      t.string :provider
      t.string :access_token
      t.string :uid
      t.string :username
      t.string :fullname
      t.integer :media
      t.integer :follows
      t.integer :followed_by
      t.string :tag1
      t.string :tag2
      t.string :tag3
      t.string :feed1
      t.string :feed2
      t.string :feed3
    end
    add_index :photostreams, :username, unique: true
  end
end
