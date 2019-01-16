module PageValidator
  class Success
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

  def self.call(title:, content:)
    errors = []

    if title.empty?
      errors << "Title can't be blank"
    end

    if title.length > 1_000
      errors << "Title is too long (maximum is 1,000 characters)"
    end

    unless title.match?(/\A[A-Za-z0-9\-_.!~*'() ]*\Z/)
      errors << "Title contains invalid characters"
    end

    if content.length > 1_000_000
      errors << "Content is too long (maximum is 1,000,000 characters)"
    end

    if errors.empty?
      Success.new
    else
      Failure.new(errors)
    end
  end
end
