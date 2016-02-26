# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'active_support/all'

ActiveSupport::Dependencies.autoload_paths += %w(lib/github_action/models)
ActiveSupport::Dependencies.autoload_paths += %w(lib/github_action/models/concerns)
ActiveSupport::Dependencies.autoload_paths += %w(lib/github_action/services)

Time.zone = 'Tokyo'

Config.load_and_set_settings(
  'config/settings.yml',
  'config/settings.local.yml')

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'run test'
RSpec::Core::RakeTask.new(:spec)
desc 'run rubocop'
RuboCop::RakeTask.new

Dir.glob('./lib/tasks/**/*.rake').each { |r| import r }
