class Tag < ActiveRecord::Base
  belongs_to :post

  def self.add post_id, tags

    return if tags.blank?

    tags = tags.split(/\s*,\s*/)

    tags.each do |tag|
      t = Tag.new({
        :post_id => post_id,
        :tag => tag.strip
      })
      t.save
    end
  end
end
