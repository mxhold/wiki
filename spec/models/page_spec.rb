require 'rails_helper'

RSpec.describe Page do
  describe "#to_param" do
    it "returns the slug" do
      expect(Page.new(slug: "myslug").to_param).to eql("myslug")
    end
  end
end
