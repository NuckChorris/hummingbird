class MoveAnimeTitlesToTable < ActiveRecord::Migration
  def up
    ## Primary Title
    # Canonical-Romaji
    execute <<-SQL
      INSERT INTO titles (language, region, title, media_type, media_id)
      SELECT 'en', 'jp', title, 'Anime', id
      FROM anime WHERE NOT english_canonical
    SQL
    # Canonical-English
    execute <<-SQL
      INSERT INTO titles (language, region, title, media_type, media_id)
      SELECT 'en', NULL, alt_title, 'Anime', id
      FROM anime WHERE english_canonical AND alt_title IS NOT NULL
    SQL
    # Add the canonical id to the anime table
    execute "UPDATE anime a SET canonical_title_id = (SELECT id FROM titles WHERE media_id = a.id)"

    ## Secondary Title
    # Secondary-Romaji
    execute <<-SQL
      INSERT INTO titles (language, region, title, media_type, media_id)
      SELECT 'en', 'jp', title, 'Anime', id
      FROM anime WHERE english_canonical
    SQL
    # Secondary-English
    execute <<-SQL
      INSERT INTO titles (language, region, title, media_type, media_id)
      SELECT 'en', NULL, alt_title, 'Anime', id
      FROM anime WHERE NOT english_canonical AND alt_title IS NOT NULL
    SQL

    remove_column :anime, :title
    remove_column :anime, :alt_title
    remove_column :anime, :english_canonical
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
