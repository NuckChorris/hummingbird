class MoveMangaTitlesToTable < ActiveRecord::Migration
  def up
    # Romaji Title
    execute <<-SQL
      INSERT INTO titles (language, region, title, media_type, media_id)
      SELECT 'en', 'jp', romaji_title, 'Manga', id
      FROM manga
    SQL
    # English Title
    execute <<-SQL
      INSERT INTO titles (language, region, title, media_type, media_id)
      SELECT 'en', NULL, english_title, 'Manga', id
      FROM manga
    SQL
    # Add the canonical id to the anime table
    execute <<-SQL
      UPDATE manga m SET canonical_title_id = (SELECT id FROM titles WHERE media_id = m.id
                                               AND language = 'en' AND region = 'jp')
    SQL

    remove_column :manga, :romaji_title
    remove_column :manga, :english_title
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
