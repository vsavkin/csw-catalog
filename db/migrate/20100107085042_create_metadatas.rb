class CreateMetadatas < ActiveRecord::Migration
  def self.up
    create_table :metadatas do |t|
      t.text "xml"
      t.string "short_description"
      t.string "standard"
      t.integer "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps
    end
  end

  def self.down
    drop_table :metadatas
  end
end
