# require_relative "../../app/procedures/page_create"
require 'rails_helper'

RSpec.describe PageCreate do
  context "given valid attributes" do
    let(:validator) do
      -> (title:, content:) { double(success?: true) }
    end

    it "saves a page" do
      page_create = PageCreate.new(validator: validator)
      result = page_create.call(title: "My Title", content: "My Content")
      expect(result).to be_success
      page = result.page
      expect(page.title).to eql "My Title"
      expect(page.content).to eql "My Content"
    end

    it "sets the slug to the title with spaces replaced with underscores" do
      page_create = PageCreate.new(validator: validator)
      result = page_create.call(title: "My Title", content: "")
      expect(result).to be_success
      page = result.page
      expect(page.title).to eql "My Title"
      expect(page.slug).to eql "My_Title"
    end
  end

  context "given invalid attributes" do
    let(:errors) { double }
    let(:validator) do
      -> (title:, content:) { double(success?: false, errors: errors) }
    end

    it "returns a failure with errors" do
      page_create = PageCreate.new(validator: validator)
      result = page_create.call(title: "", content: "")
      expect(result).not_to be_success
      expect(result.errors).to eql errors
    end
  end
end
