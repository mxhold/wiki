module PageCreate
  class Success
    attr_reader :page
    def initialize(page)
      @page = page
    end

    def success?
      true
    end
  end

  class Failure
    attr_reader :page
    def initialize(page)
      @page = page
    end

    def success?
      false
    end
  end

  def self.call(title:, content:)
    page = Page.new(
      title: title,
      content: content,
      slug: title.gsub(/ /, '_'),
    )

    if page.save
      Success.new(page)
    else
      Failure.new(page)
    end
  end
end
