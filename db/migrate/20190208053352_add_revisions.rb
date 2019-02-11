class AddRevisions < ActiveRecord::Migration[5.2]
  def up
    execute <<~'SQL'
    ALTER TABLE pages
      ADD COLUMN created_at TIMESTAMP WITH TIME ZONE;
    SQL
    execute <<~'SQL'
    ALTER TABLE pages
      ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE;
    SQL
    execute <<~'SQL'
    CREATE TABLE page_revisions (
      id serial PRIMARY KEY,
      content text NOT NULL,
      CONSTRAINT content_not_too_long CHECK (char_length(content) <= 1000000),
      slug text NOT NULL,
      CONSTRAINT slug_uses_uri_unreserved_characters CHECK (slug ~ '\A[A-Za-z0-9\-_.!~*''()]*\Z'),
      CONSTRAINT slug_not_empty CHECK (slug != ''),
      CONSTRAINT slug_not_too_long CHECK (char_length(slug) <= 1000),
      title text NOT NULL,
      CONSTRAINT title_not_empty CHECK (title != ''),
      CONSTRAINT title_not_too_long CHECK (char_length(title) <= 1000),
      page_id integer REFERENCES pages(id) NOT NULL,
      comment text,
      CONSTRAINT comment_not_too_long CHECK (char_length(comment) <= 50),
      created_at TIMESTAMP WITH TIME ZONE NOT NULL
    );
    SQL
  end
end
