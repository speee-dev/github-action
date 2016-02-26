# frozen_string_literal: true
Octokit.configure do |c|
  c.access_token = Settings.github.access_token
  c.auto_paginate = true
end

namespace :import do
  desc 'import pull requests created on target day(default: yesterday)'
  task :daily, [:date] do |_, args|
    DailyImporter.new(target_date: args.date).run
  end
end
