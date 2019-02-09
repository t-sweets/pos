# frozen_string_literal: true

require 'slack'

Slack.configure do |config|
  config.token = ENV['SLACK_API_KEY']
end
