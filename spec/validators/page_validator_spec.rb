require_relative "../../app/validators/page_validator"

RSpec.describe PageValidator do
  let(:valid_attributes) { { title: "My Title", content: "My Content" } }
  describe "call" do
    it "returns a success on valid attributes" do
      result = PageValidator.call(valid_attributes)
      expect(result).to be_success
    end

    describe "title" do
      it "can't be empty" do
        result = PageValidator.call(valid_attributes.merge(title: ""))
        expect(result).not_to be_success
        expect(result.errors).to eql ["Title can't be blank"]
      end

      it "can't exceed 1 000 characters" do
        result = PageValidator.call(valid_attributes.merge(title: "A" * 1_000))
        expect(result).to be_success

        result = PageValidator.call(valid_attributes.merge(title: "A" * 1_001))
        expect(result).not_to be_success
        expect(result.errors).to eql ["Title is too long (maximum is 1,000 characters)"]
      end

      it "can only contain spaces plus URI unreserved characters (see: https://tools.ietf.org/html/rfc2396#section-2.3)" do
        unreserved_characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.!~*'() "

        result = PageValidator.call(valid_attributes.merge(title: unreserved_characters))
        expect(result).to be_success

        result = PageValidator.call(valid_attributes.merge(title: "%"))
        expect(result).not_to be_success
        expect(result.errors).to eql ["Title contains invalid characters"]
      end
    end

    describe "content" do
      it "can't exceed 1 000 000 characters" do
        result = PageValidator.call(valid_attributes.merge(content: "A" * 1_000_00))
        expect(result).to be_success

        result = PageValidator.call(valid_attributes.merge(content: "A" * 1_000_001))
        expect(result).not_to be_success
        expect(result.errors).to eql ["Content is too long (maximum is 1,000,000 characters)"]
      end
    end
  end
end
