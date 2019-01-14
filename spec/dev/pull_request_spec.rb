require 'git'

RSpec.describe "each pull request" do
  let(:git) { Git.open(File.expand_path("../..", __dir__)) }

  it "must not contain changes to both app/ and db/migrate/ (see README)" do
    migration_file_changed = nil
    app_file_changed = nil
    git.log.between("origin/master", "HEAD").each do |commit|
      files_changed = commit.diff_parent.name_status.keys
      migration_file_changed ||= files_changed.find { |f| f.start_with?("db/migrate") }
      app_file_changed ||= files_changed.find { |f| f.start_with?("app") }

      if migration_file_changed && app_file_changed
        fail "Changed both:\n  #{migration_file_changed}\n  #{app_file_changed}"
      end
    end
  end
end
