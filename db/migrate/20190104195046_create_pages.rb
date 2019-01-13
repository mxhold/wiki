class CreatePages < ActiveRecord::Migration[5.2]
  def up
    execute <<~'SQL'
    CREATE TABLE pages (
      id serial PRIMARY KEY,
      content text NOT NULL,
      CONSTRAINT content_not_too_long CHECK (char_length(content) <= 1000000),
      slug text NOT NULL,
      CONSTRAINT slug_uses_uri_unreserved_characters CHECK (slug ~ '\A[A-Za-z0-9\-_.!~*''()]*\Z'),
      CONSTRAINT slug_not_empty CHECK (slug != ''),
      CONSTRAINT slug_not_too_long CHECK (char_length(slug) <= 1000),
      title text NOT NULL,
      CONSTRAINT title_not_empty CHECK (title != ''),
      CONSTRAINT title_not_too_long CHECK (char_length(title) <= 1000)
    );
    SQL
  end
end
