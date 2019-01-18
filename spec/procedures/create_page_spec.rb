require 'rails_helper'

RSpec.describe CreatePage do
  it "saves a page" do
    result = CreatePage.call(title: "My Title", content: "My Content")
    expect(result).to be_success
    page = result.unwrap!
    expect(page.title).to eql "My Title"
    expect(page.content).to eql "My Content"
  end

  it "sets the slug to the title with spaces replaced with underscores" do
    result = CreatePage.call(title: "My Title", content: "")
    expect(result).to be_success
    page = result.unwrap!
    expect(page.title).to eql "My Title"
    expect(page.slug).to eql "My_Title"
  end

  it "returns an err on validation error" do
    result = CreatePage.call(title: "", content: "")
    expect(result).not_to be_success
    page = result.unwrap_error!
    expect(page).not_to be_valid
  end
end
