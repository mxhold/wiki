class Page < ApplicationRecord
  validates :title,
    presence: true,
    length: { maximum: 1_000 },
    format: {
      with: /\A[A-Za-z0-9\-_.!~*'() ]*\z/,
      message: "contains invalid characters",
    }
  validates :content,
    exclusion: { in: [nil] },
    length: { maximum: 1_000_000 }

  def to_param
    slug
  end

  def title=(value)
    super(value)
    if value
      self.slug = value.tr(" ", "_")
    end
  end
end
