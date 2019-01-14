# wiki

This is a basic wiki application intended for managing personal data.

## Prerequisites

- Ruby 2.5.3
- PostgreSQL 10

You can probably use earlier or later versions of the above dependencies but this project will only be tested using the versions listed.

## Setup

For initial setup, run `bin/setup`.

*Note*: when running `bin/bundle install` (which the above setup script runs) on non-Windows platforms you may see the following warning:

>The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.

This can be safely ignored (see: [this comment](https://github.com/tzinfo/tzinfo-data/issues/12#issuecomment-279554001) for more info). You can run `bundle config --local disable_platform_warnings true` to silence this warning for this app specifically.

To start the server, run `bin/rails s`.

To run the full test suite, run `bin/rspec spec`.

To run a specific test, run e.g. `bin/rspec spec/path/to/file_spec.rb:15` to run the test on line 15.

## Database migrations

Some restrictions around migrations I intend to maintain for this project that differ from most Rails applications:

1. Once a migration is run in production, it cannot be changed. This is to prevent the development database from getting out of sync with production.
2. Each release can contain either database changes or application changes, but not both. See [this post](https://maxwellholder.com/2019/01/09/database-migration-strategies.html#decoupled-releases) for reasoning.
3. All migrations are irreversible. Since database and application changes are decoupled due to (2) above, if there's an issue with a database migration it should not require an immediate rollback. Instead, you should rollforward with any necessary fixes made in an additional migration. This reduces the complexity of adding new migrations and often many kinds of migrations cannot be rolled back anyway.
4. Development databases should be built from the `structure.sql` (which has been chosen over the `schema.rb` format since it captures Postgres-specific features) not by running migrations. This avoids the necessity to update older migrations once they are run.

The needs of this application (particularly right now in early development) do not really necessitate this level of discipline but I'm choosing to do this as a kind of experimental practice.
