class FullMangaSerializer < MangaSerializer
  embed :ids, include: true

  attributes :cover_image,
             :cover_image_top_offset

  has_one :manga_library_entry
  has_many :featured_castings, root: :castings
  has_many :trending_reviews, root: :reviews

  def manga_library_entry
    scope && MangaLibraryEntry.where(user_id: scope.id, manga_id: object.id).first
  end

  def cover_image
    object.cover_image_file_name ? object.cover_image.url(:thumb) : nil
  end

  def cover_image_top_offset
    object.cover_image_top_offset || 0
  end

  def featured_castings
    object.castings.where(featured: true).includes(:character).sort_by {|x| x.order || 100 }
  end

  def trending_reviews
    object.reviews.includes(:user).order("wilson_score DESC").limit(4)
  end
end
