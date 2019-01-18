require_relative "../../lib/result.rb"

RSpec.describe Result::Success do
  describe "#==" do
    context "two Success with same value" do
      it "is true" do
        success1 = Result::Success.new("foo")
        success2 = Result::Success.new("foo")
        expect(success1 == success2).to eq(true)
      end
    end

    context "two Success with different values" do
      it "is false" do
        success1 = Result::Success.new("foo")
        success2 = Result::Success.new("bar")
        expect(success1 == success2).to eq(false)
      end
    end

    context "Success and Failure" do
      it "is false" do
        success = Result::Success.new(1)
        failure = Result::Failure.new(:whoops)
        expect(success == failure).to eq(false)
      end
    end
  end

  describe "#eql?" do
    it "is equivalent to #==" do
      success1 = Result::Success.new("foo")
      success2 = Result::Success.new("foo")
      expect(success1).to eql(success2)
    end
  end

  describe "#success?" do
    it "is true" do
      expect(Result::Success.new(1).success?).to eq(true)
    end
  end

  describe "#failure?" do
    it "is false" do
      expect(Result::Success.new(1).failure?).to eq(false)
    end
  end

  describe "#unwrap!" do
    it "returns the value" do
      expect(Result::Success.new(1).unwrap!).to eq(1)
    end
  end

  describe "#unwrap_error!" do
    it "raises an error" do
      expect do
        Result::Success.new("hello").unwrap_error!
      end.to raise_error(Result::UnwrapError, /called #unwrap_error! on #<Result::Success:.* @value="hello">/)
    end
  end
end

RSpec.describe Result::Failure do
  describe "#==" do
    context "two Failure with same error" do
      it "is true" do
        failure1 = Result::Failure.new(:error1)
        failure2 = Result::Failure.new(:error1)
        expect(failure1 == failure2).to eq(true)
      end
    end

    context "two Failure with different error" do
      it "is false" do
        failure1 = Result::Failure.new(:error1)
        failure2 = Result::Failure.new(:error2)
        expect(failure1 == failure2).to eq(false)
      end
    end

    context "Failure and Ok" do
      it "is false" do
        failure = Result::Failure.new(:error1)
        success = Result::Success.new(1)
        expect(failure == success).to eq(false)
      end
    end
  end

  describe "#eql?" do
    it "is equivalent to #==" do
      failure1 = Result::Failure.new(:error1)
      failure2 = Result::Failure.new(:error1)
      expect(failure1).to eql(failure2)
    end
  end

  describe "#success?" do
    it "is false" do
      expect(Result::Failure.new(:error).success?).to eq(false)
    end
  end

  describe "#failure?" do
    it "is true" do
      expect(Result::Failure.new(:error).failure?).to eq(true)
    end
  end

  describe "#unwrap!" do
    it "raises an error" do
      expect do
        Result::Failure.new(:whoops).unwrap!
      end.to raise_error(Result::UnwrapError, /called #unwrap! on #<Result::Failure:.* @error=:whoops>/)
    end
  end

  describe "#unwrap_error!" do
    it "returns the error" do
      expect(Result::Failure.new(:whoops).unwrap_error!).to eq(:whoops)
    end
  end
end
