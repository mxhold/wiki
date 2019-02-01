require 'rails_helper'

RSpec.feature "Page management" do
  scenario "User creates a page" do
    visit "/"
    click_link "Create a page"

    fill_in("Title", with: "My Example Page")
    fill_in("Content", with: "This is my page")
    click_button("Create")

    expect(page).to have_current_path("/My_Example_Page")
    expect(page).to have_content("Page was successfully created.")
    expect(page).to have_content("This is my page")

    click_link "Home"
    expect(page).to have_current_path("/")
    expect(page).to have_link("My Example Page", href: "/My_Example_Page")
  end
end
