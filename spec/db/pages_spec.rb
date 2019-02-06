require 'pg'
require 'yaml'

RSpec.describe "pages table" do
  before(:all) do
    database_configuration = YAML.load_file(File.expand_path("../../config/database.yml", __dir__))["test"]

    @connection = PG.connect(dbname: database_configuration["database"])
  end

  around(:each) do |example|
    rollback_transaction = Class.new(StandardError)
    begin
      @connection.transaction do
        example.run
        raise rollback_transaction
      end
    rescue rollback_transaction
    end
  end

  def insert_into_pages(content: "content", slug: "slug", title: "title")
    @connection.exec(
      "INSERT INTO pages (content, slug, title) VALUES ($1, $2, $3)",
      [content, slug, title]
    )
  end

  describe "content" do
    it "can't be null" do
      expect do
        insert_into_pages(content: nil)
      end.to raise_error(PG::NotNullViolation)
    end

    it "can be empty" do
      expect do
        insert_into_pages(content: "")
      end.not_to raise_error
    end

    it "can't exceed 1,000,000 characters" do
      expect do
        insert_into_pages(content: "A" * 1_000_000)
      end.not_to raise_error

      expect do
        insert_into_pages(content: "A" * 1_000_001)
      end.to raise_error(PG::CheckViolation, /content_not_too_long/)
    end
  end

  describe "slug" do
    it "can't be null" do
      expect do
        insert_into_pages(slug: nil)
      end.to raise_error(PG::NotNullViolation)
    end

    it "can't be an empty string" do
      expect do
        insert_into_pages(slug: "")
      end.to raise_error(PG::CheckViolation, /slug_not_empty/)
    end

    it "can only contain URI unreserved characters (see: https://tools.ietf.org/html/rfc2396#section-2.3)" do
      expect do
        insert_into_pages(slug: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.!~*'()")
      end.not_to raise_error

      expect do
        insert_into_pages(slug: "my slug")
      end.to raise_error(PG::CheckViolation, /slug_uses_uri_unreserved_characters/)
    end

    it "can't exceed 1000 characters" do
      expect do
        insert_into_pages(slug: "A" * 1_000)
      end.not_to raise_error

      expect do
        insert_into_pages(slug: "A" * 1_001)
      end.to raise_error(PG::CheckViolation, /slug_not_too_long/)
    end

    it "must be unique after converting to lowercase" do
      insert_into_pages(slug: "MyPage")

      expect do
        insert_into_pages(slug: "mypage")
      end.to raise_error(PG::UniqueViolation, /pages_slug_idx/)
    end
  end

  describe "title" do
    it "can't be null" do
      expect do
        insert_into_pages(title: nil)
      end.to raise_error(PG::NotNullViolation)
    end

    it "can't be an empty string" do
      expect do
        insert_into_pages(title: "")
      end.to raise_error(PG::CheckViolation, /title_not_empty/)
    end

    it "can't exceed 1000 characters" do
      expect do
        insert_into_pages(title: "A" * 1_000)
      end.not_to raise_error

      expect do
        insert_into_pages(title: "A" * 1_001)
      end.to raise_error(PG::CheckViolation, /title_not_too_long/)
    end
  end
end
