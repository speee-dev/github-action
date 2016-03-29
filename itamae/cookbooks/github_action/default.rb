# frozen_string_literal: true
node.validate! do
  {
    github_action: {
      allowed_ips: array_of(string),
    },
  }
end

user 'github-action'
execute 'usermod -aG docker github-action'

remote_file '/etc/rc.d/init.d/github-action' do
  owner 'root'
  group 'root'
  mode '0755'
end

# ================================================================================
# nginx vhost settings
# ================================================================================
template '/etc/nginx/conf.d/default.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  variables node.github_action
end

directory '/var/log/nginx/github-action' do
  owner 'nginx'
  group 'nginx'
  mode '0755'
end

service 'nginx' do
  action :reload
end

# ================================================================================
# start service
# ================================================================================
service 'github-action' do
  action [:enable, :start]
end

# ================================================================================
# import batch
# ================================================================================
directory '/usr/local/github_action' do
  owner 'github-action'
  group 'github-action'
  mode '0755'
end

git '/usr/local/github_action/import' do
  repository 'git://github.com/speee-dev/github-action.git'
  revision 'origin/master'
  user 'github-action'
end

remote_file '/usr/local/github_action/import/config/settings.local.yml' do
  source 'files/local/settings.local.yml'
  owner 'github-action'
  group 'github-action'
  mode '0644'
end

BUNDLE_COMMAND =
  '. /etc/profile.d/rbenv.sh;'\
  'bundle install --path vendor/bundle'

execute BUNDLE_COMMAND do
  user 'github-action'
  cwd '/usr/local/github_action/import'
end

execute '/usr/local/github_action/import/rake create_index' do
  user 'github-action'
end

remote_file '/home/github-action/crontab' do
  owner 'github-action'
  group 'github-action'
  mode '0644'
end

execute 'crontab /home/github-action/crontab' do
  user 'github-action'
end
