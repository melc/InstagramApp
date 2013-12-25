class CreatePhotostreams < ActiveRecord::Migration
  def change
    create_table :photostreams do |t|
      t.string :client_id
      t.string :secret_code
      t.string :access_token

      t.timestamps
    end
  end
end
