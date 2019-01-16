class PageCreate
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
    attr_reader :errors
    def initialize(errors)
      @errors = errors
    end

    def success?
      false
    end
  end

  def initialize(validator:)
    @validator = validator
  end

  def call(title:, content:)
    validation_result = @validator.call(
      title: title,
      content: content,
    )

    if validation_result.success?
      page = Page.create!(
        title: title,
        content: content,
        slug: title.gsub(/ /, '_'),
      )
      Success.new(page)
    else
      Failure.new(validation_result.errors)
    end
  end
end
