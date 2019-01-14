require 'git'

RSpec.describe "each pull request" do
  let(:git) { Git.open(File.expand_path("../..", __dir__)) }

  it "must only change database in isolation" do
    files_changed = git.log.between("origin/master", "HEAD").flat_map do |commit|
      commit.diff_parent.name_status.keys
    end

    migration_file_changed = files_changed.find { |f| f.start_with?("db/migrate") }
    # We'll be cautious and assume anything outside of db/ and spec/ could impact the application
    app_file_changed = files_changed.find { |f| !f.start_with?("db") && !f.start_with?("spec") }

    if migration_file_changed && app_file_changed
      fail "Changed both:\n  #{migration_file_changed}\n  #{app_file_changed}"
    end
  end
end
