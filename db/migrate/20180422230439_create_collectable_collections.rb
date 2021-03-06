# frozen_string_literal: true

class CreateCollectableCollections < ActiveRecord::Migration[5.1]
  def up
    create_table :collectable_collections, id: :uuid do |t|
      t.string :collectable_type
      t.uuid :collectable_id
      t.belongs_to :collection, index: true, type: :uuid
      t.integer :count, null: false, default: 1
      t.timestamps
    end
    add_index :collectable_collections,
              %i[collectable_type collectable_id collection_id],
              unique: true,
              name: 'index_on_collectable_collection_unique'
  end

  def down
    remove_index :collectable_collections, name: 'index_on_collectable_collection_unique'
    drop_table :collectable_collections
  end
end
