class Page < ApplicationRecord
  validates :title,
    presence: true,
    length: { maximum: 1_000 },
    format: {
      with: /\A[A-Za-z0-9\-_.!~*'() ]*\z/,
      message: "contains invalid characters",
    }
  validate :title_must_be_unique
  validates :content,
    exclusion: { in: [nil] },
    length: { maximum: 1_000_000 }

  def to_param
    slug
  end

  def self.exists_with_slug_ignoring_case?(slug)
    with_slug_ignoring_case(slug).exists?
  end

  def self.find_by_slug_ignoring_case!(slug)
    with_slug_ignoring_case(slug).first!
  end

  def title=(value)
    super(value)
    if value
      self.slug = value.tr(" ", "_")
    end
  end

  private

  def self.with_slug_ignoring_case(slug)
    where(arel_table[:slug].lower.eq(slug.downcase))
  end

  def title_must_be_unique
    if Page.exists_with_slug_ignoring_case?(slug)
      errors.add(:title, :taken)
    end
  end
end
