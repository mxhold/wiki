require 'rails_helper'

RSpec.describe Page do
  describe "validations" do
    let(:page) { Page.new(title: "title", slug: "slug", content: "content") }

    it "can be valid" do
      expect(page).to be_valid
    end

    describe "title" do
      it "can't be nil" do
        page.title = nil
        expect(page).not_to be_valid
        expect(page.errors.full_messages_for(:title)).to eql ["Title can't be blank"]
      end

      it "can't be blank" do
        page.title = ""
        expect(page).not_to be_valid
        expect(page.errors.full_messages_for(:title)).to eql ["Title can't be blank"]
      end

      it "can't exceed 1 000 characters" do
        page.title = "A" * 1000
        expect(page).to be_valid

        page.title = "A" * 1001
        expect(page).not_to be_valid
        expect(page.errors.full_messages_for(:title)).to eql ["Title is too long (maximum is 1000 characters)"]
      end

      it "can only contain spaces plus URI unreserved characters (see: https://tools.ietf.org/html/rfc2396#section-2.3)" do
        page.title = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.!~*'() "
        expect(page).to be_valid

        page.title = "slug\n"
        expect(page).not_to be_valid
        expect(page.errors.full_messages_for(:title)).to eql ["Title contains invalid characters"]
      end

      it "must be unique when converted to slug and downcased" do
        Page.create!(title: "mypage", content: "")
        page.title = "MyPage"
        expect(page).not_to be_valid
        expect(page.errors.full_messages_for(:title)).to eql ["Title has already been taken"]
      end
    end

    describe "content" do
      it "can't exceed 1 000 000 characters" do
        page.content = "A" * 1_000_000
        expect(page).to be_valid

        page.content = "A" * 1_000_001
        expect(page).not_to be_valid
        expect(page.errors.full_messages_for(:content)).to eql ["Content is too long (maximum is 1000000 characters)"]
      end
    end
  end

  describe "slug" do
    it "is computed from the title" do
      page = Page.new(title: "Hello world")
      expect(page.slug).to eql("Hello_world")
    end
  end

  describe ".exists_with_slug_ignoring_case?" do
    it "returns true if page exists that would be found with provided slug" do
      Page.create!(title: "MyPage", content: "")
      expect(Page.exists_with_slug_ignoring_case?("MYPAGE")).to eql(true)
      expect(Page.exists_with_slug_ignoring_case?("notapage")).to eql(false)
    end
  end

  describe ".find_by_slug_ignoring_case!" do
    it "finds the page matching the slug, case insensitive" do
      page = Page.create(title: "MyPage", content: "")
      expect(Page.find_by_slug_ignoring_case!("MYPAGE")).to eql(page)
    end

    it "raises ActiveRecord::RecordNotFound if none found" do
      expect do
        Page.find_by_slug_ignoring_case!("foo")
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
