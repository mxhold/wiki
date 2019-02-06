require 'rails_helper'

RSpec.describe "page management" do
  it "creates a page and redirects to it" do
    get "/pages/new"
    expect(response.body).to include("New page")

    post "/pages", params: { page: { title: "My Title", content: "This is my page" }}

    expect(response).to redirect_to("/My_Title")
    follow_redirect!
    expect(response.body).to include("Page was successfully created.")

    expect(Page.count).to eql(1)
    page = Page.first
    expect(page.title).to eql("My Title")
    expect(page.slug).to eql("My_Title")
    expect(page.content).to eql("This is my page")
  end

  it "displays an error on invalid input" do
    post "/pages", params: { page: { title: "", content: "This is my page" }}

    expect(Page.count).to eql(0)
    expect(response.body).to include("error prohibited this page from being saved")
  end

  it "sanitizes page content" do
    post "/pages", params: { page: { title: "Title", content: "<b>Bold is allowed</b> <a href='https://google.com'>simple links allowed</a> <a href='javascript:alert(\"hi\");'>js link not allowed</a>" }}
    follow_redirect!

    expect(response.body).to include("<b>Bold is allowed</b> <a href=\"https://google.com\">simple links allowed</a> <a>js link not allowed</a>")
  end

  it "sorts pages alphabetically by title" do
    Page.create!(title: "aa", content: "")
    Page.create!(title: "CCC", content: "")
    Page.create!(title: "AAA", content: "")
    Page.create!(title: "BBB", content: "")

    get "/"
    expect(response.body).to match(/aa.*AAA.*BBB.*CCC.*/m)
  end
end
