class CreateTriggers < ActiveRecord::Migration
  def change
    create_table :triggers do |t|
      t.string :name
      t.text :description
      t.string :http_type
      t.string :http_method
      t.string :params
      t.string :source
      t.text :content_to_atom
      t.references :service

      t.timestamps
    end
    add_index :triggers, :service_id
  end
end
