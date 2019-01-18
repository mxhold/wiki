# require_relative "../../app/procedures/page_create"
require 'rails_helper'

RSpec.describe PageCreate do
  it "saves a page" do
    result = PageCreate.call(title: "My Title", content: "My Content")
    expect(result).to be_success
    page = result.page
    expect(page.title).to eql "My Title"
    expect(page.content).to eql "My Content"
  end

  it "sets the slug to the title with spaces replaced with underscores" do
    result = PageCreate.call(title: "My Title", content: "")
    expect(result).to be_success
    page = result.page
    expect(page.title).to eql "My Title"
    expect(page.slug).to eql "My_Title"
  end

  it "returns an err on validation error" do
    result = PageCreate.call(title: "", content: "")
    expect(result).not_to be_success
    page = result.page
    expect(page).not_to be_valid
  end
end
