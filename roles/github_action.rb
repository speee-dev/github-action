# frozen_string_literal: true
include_recipe '../cookbooks/initialize/default.rb'
include_recipe '../cookbooks/rbenv/default.rb'
include_recipe '../cookbooks/direnv/default.rb'
include_recipe '../cookbooks/docker/default.rb'
include_recipe '../cookbooks/nginx/default.rb'
include_recipe '../cookbooks/github_action/default.rb'
