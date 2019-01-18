require_relative "../../lib/result"

module CreatePage
  def self.call(title:, content:)
    page = Page.new(
      title: title,
      content: content,
      slug: title.gsub(/ /, '_'),
    )

    if page.save
      Result::Success.new(page)
    else
      Result::Failure.new(page)
    end
  end
end
