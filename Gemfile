source "https://rubygems.org"
ruby RUBY_VERSION

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!

# To upgrade, run `bundle update github-pages`.
gem "github-pages", group: :jekyll_plugins

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima"

# Ruby 3.x doesn't have webrick; so it needs to be manually added
# https://github.com/github/pages-gem/issues/752#issuecomment-764647862
gem "webrick"

# Squelch Jekyll run's faraday message by installing the gem it recommends
gem "faraday-retry"
