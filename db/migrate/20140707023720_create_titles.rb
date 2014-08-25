class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.references :media, index: true, polymorphic: true
      t.string :title, null: false
      t.string :language, null: false
      t.string :region
      t.string :kind
    end
    add_index :titles, [:language, :region, :kind]

    add_column :anime, :canonical_title_id, :integer
    add_column :manga, :canonical_title_id, :integer
  end
end
