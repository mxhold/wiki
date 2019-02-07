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

  it "displays an error on application-level uniqueness validation failure" do
    Page.create!(title: "MyPage", content: "")

    post "/pages", params: { page: { title: "mypage", content: "" }}
    expect(Page.count).to eql(1)
    expect(response.body).to include("Title has already been taken")
  end

  it "displays an error on database uniqueness constraint failure" do
    Page.create!(title: "MyPage", content: "")

    # simulate race condition by skipping app-level validation
    expect(Page).to receive(:exists_with_slug_ignoring_case?) { false }

    post "/pages", params: { page: { title: "mypage", content: "" }}
    expect(Page.count).to eql(1)
    expect(response.body).to include("Title has already been taken")
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

  it "looks up pages by slug ignoring case" do
    Page.create!(title: "MyPage", content: "You found it")

    get "/mypage"

    expect(response.body).to include("You found it")
  end

  it "allows pages that contain dots in slug" do
    post "/pages", params: { page: { title: "my.page", content: "You found it" }}
    get "/my.page"

    expect(response.body).to include("You found it")
  end

  it "allows pages that look like they end in file extensions" do
    post "/pages", params: { page: { title: "_.js", content: "Underscore dot js" }}
    get "/_.js"

    expect(request.format.to_s).to eql("text/html")
    expect(response.body).to include("Underscore dot js")
  end
end
