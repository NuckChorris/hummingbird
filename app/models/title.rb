# == Schema Information
#
# Table name: titles
#
#  id         :integer          not null, primary key
#  media_id   :integer
#  media_type :string(255)
#  title      :string(255)      not null
#  language   :string(255)      not null
#  region     :string(255)
#  kind       :string(255)
#

class Title < ActiveRecord::Base
  belongs_to :media, polymorphic: true
end
