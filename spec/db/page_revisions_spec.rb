RSpec.describe "page_revisions table", :db_without_rails do
  before(:each) do
    result = @connection.exec(
      "INSERT INTO pages (content, slug, title) VALUES ($1, $2, $3) RETURNING id",
      ["my page", "My_Page", "My Page"]
    )
    @existing_page_id = result[0].fetch("id")
  end

  def insert_into_page_revisions(
    content: "content",
    slug: "slug",
    title: "title",
    created_at: Time.now,
    page_id: :unset,
    comment: nil
  )
    if page_id == :unset
      page_id = @existing_page_id
    end
    @connection.exec(
      "INSERT INTO page_revisions (content, slug, title, created_at, page_id, comment) VALUES ($1, $2, $3, $4, $5, $6)",
      [content, slug, title, created_at, page_id, comment]
    )
  end

  describe "valid row" do
    it "exists" do
      expect do
        insert_into_page_revisions
      end.not_to raise_error
    end
  end

  describe "page_id" do
    it "can't be null" do
      expect do
        insert_into_page_revisions(page_id: nil)
      end.to raise_error(PG::NotNullViolation)
    end
    
    it "references pages table" do
      nonexistent_page_id = 99999
      expect do
        insert_into_page_revisions(page_id: nonexistent_page_id)
      end.to raise_error(PG::ForeignKeyViolation)
    end
  end

  describe "content" do
    it "can't be null" do
      expect do
        insert_into_page_revisions(content: nil)
      end.to raise_error(PG::NotNullViolation)
    end

    it "can be empty" do
      expect do
        insert_into_page_revisions(content: "")
      end.not_to raise_error
    end

    it "can't exceed 1,000,000 characters" do
      expect do
        insert_into_page_revisions(content: "A" * 1_000_000)
      end.not_to raise_error

      expect do
        insert_into_page_revisions(content: "A" * 1_000_001)
      end.to raise_error(PG::CheckViolation, /content_not_too_long/)
    end
  end

  describe "slug" do
    it "can't be null" do
      expect do
        insert_into_page_revisions(slug: nil)
      end.to raise_error(PG::NotNullViolation)
    end

    it "can't be an empty string" do
      expect do
        insert_into_page_revisions(slug: "")
      end.to raise_error(PG::CheckViolation, /slug_not_empty/)
    end

    it "can only contain URI unreserved characters (see: https://tools.ietf.org/html/rfc2396#section-2.3)" do
      expect do
        insert_into_page_revisions(slug: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.!~*'()")
      end.not_to raise_error

      expect do
        insert_into_page_revisions(slug: "my slug")
      end.to raise_error(PG::CheckViolation, /slug_uses_uri_unreserved_characters/)
    end

    it "can't exceed 1000 characters" do
      expect do
        insert_into_page_revisions(slug: "A" * 1_000)
      end.not_to raise_error

      expect do
        insert_into_page_revisions(slug: "A" * 1_001)
      end.to raise_error(PG::CheckViolation, /slug_not_too_long/)
    end

    it "allows multiple revisions for a single page" do
      insert_into_page_revisions(slug: "MyPage")

      expect do
        insert_into_page_revisions(slug: "mypage")
      end.not_to raise_error
    end
  end

  describe "title" do
    it "can't be null" do
      expect do
        insert_into_page_revisions(title: nil)
      end.to raise_error(PG::NotNullViolation)
    end

    it "can't be an empty string" do
      expect do
        insert_into_page_revisions(title: "")
      end.to raise_error(PG::CheckViolation, /title_not_empty/)
    end

    it "can't exceed 1000 characters" do
      expect do
        insert_into_page_revisions(title: "A" * 1_000)
      end.not_to raise_error

      expect do
        insert_into_page_revisions(title: "A" * 1_001)
      end.to raise_error(PG::CheckViolation, /title_not_too_long/)
    end
  end

  describe "created_at" do
    it "can't be null" do
      expect do
        insert_into_page_revisions(created_at: nil)
      end.to raise_error(PG::NotNullViolation)
    end
  end

  describe "comment" do
    it "can't exceed 50 characters" do
      expect do
        insert_into_page_revisions(comment: "A" * 50)
      end.not_to raise_error

      expect do
        insert_into_page_revisions(comment: "A" * 51)
      end.to raise_error(PG::CheckViolation, /comment_not_too_long/)
    end

    it "can be empty" do
      expect do
        insert_into_page_revisions(comment: "")
      end.not_to raise_error
    end

    it "can be null" do
      expect do
        insert_into_page_revisions(comment: nil)
      end.not_to raise_error
    end
  end
end
