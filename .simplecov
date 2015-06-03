formatters = ENV['CI'] ? [] : [SimpleCov::Formatter::HTMLFormatter]

# Bring in Codecov if the token is set.
if ENV['CODECOV_TOKEN']
  require 'codecov'
  formatters << SimpleCov::Formatter::Codecov
end

# Bring in codeclimate if the token is set.
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  formatters << CodeClimate::TestReporter::Formatter
end

SimpleCov.formatters = formatters

# Start up SimpleCov to check the code coverage with these settings
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
  add_filter "/.bundle/"
  add_filter "/test/"
end