class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls, id: :uuid do |t|
      t.uuid :user_id, null: false, index: true
      t.string :original_url, null: false
      t.string :slug

      t.timestamps
    end

    add_index :urls, :slug, unique: true, where: 'slug IS NOT NULL'
  end
end
