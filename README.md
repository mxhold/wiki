# wiki

This is a basic wiki application intended for managing personal data.

## Prerequisites

- Ruby 2.6
- PostgreSQL 11

You can probably use earlier versions of the above dependencies but this project will only be tested using the versions listed.

## Setup

For initial setup, run `bin/setup`.

*Note*: when running `bin/bundle install` (which the above setup script runs) on non-Windows platforms you may see the following warning:

>The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.

This can be safely ignored (see: [this comment](https://github.com/tzinfo/tzinfo-data/issues/12#issuecomment-279554001) for more info). You can run `bundle config --local disable_platform_warnings true` to silence this warning for this app specifically.

To start the server, run `bin/rails s`.

To run the full test suite, run `bin/rspec spec`.

To run a specific test, run e.g. `bin/rspec spec/path/to/file_spec.rb:15` to run the test on line 15.
