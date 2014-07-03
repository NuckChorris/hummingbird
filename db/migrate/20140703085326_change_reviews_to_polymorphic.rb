class ChangeReviewsToPolymorphic < ActiveRecord::Migration
  def up
    rename_column :reviews, :anime_id, :media_id
    add_column :reviews, :media_type, :string
    Review.reset_column_information
    Review.update_all media_type: "Anime"
    add_index :reviews, [:media_id, :media_type]
  end
  def down
    remove_index :reviews, [:media_id, :media_type]
    rename_column :reviews, :media_id, :anime_id
    remove_column :reviews, :media_type
  end
end
