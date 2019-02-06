class AddPagesSlugIndex < ActiveRecord::Migration[5.2]
  def up
    execute <<~'SQL'
    CREATE UNIQUE INDEX pages_slug_idx ON pages (lower(slug));
    SQL
  end
end
