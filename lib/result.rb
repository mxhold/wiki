module Result
  class UnwrapError < TypeError
  end

  class Success
    def initialize(value)
      @value = value
    end

    def ==(other)
      other.is_a?(Success) && unwrap! == other.unwrap!
    end
    alias_method :eql?, :==

    def success?
      true
    end

    def failure?
      false
    end

    def unwrap!
      @value
    end

    def unwrap_error!
      fail UnwrapError, "called #unwrap_error! on #{inspect}"
    end
  end

  class Failure
    def initialize(error)
      @error = error
    end

    def ==(other)
      other.is_a?(Failure) && unwrap_error! == other.unwrap_error!
    end
    alias_method :eql?, :==

    def success?
      false
    end

    def failure?
      true
    end

    def unwrap!
      fail UnwrapError, "called #unwrap! on #{inspect}"
    end

    def unwrap_error!
      @error
    end
  end
end
