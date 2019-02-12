require 'pg'
require 'yaml'

RSpec.configure do |c|
  c.before(:all, :db_without_rails) do |example|
    database_configuration = YAML.load_file(File.expand_path("../../config/database.yml", __dir__))["test"]

    @connection = PG.connect(dbname: database_configuration["database"])
  end

  c.around(:each, :db_without_rails) do |example|
    rollback_transaction = Class.new(StandardError)
    begin
      @connection.transaction do
        example.run
        raise rollback_transaction
      end
    rescue rollback_transaction
    end
  end
end
