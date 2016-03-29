# frozen_string_literal: true
package 'nginx'

remote_file '/etc/nginx/nginx.conf' do
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file '/etc/nginx/conf.d/default.conf' do
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file '/etc/logrotate.d/nginx' do
  owner 'root'
  group 'root'
  mode '0644'
end

directory '/var/log/nginx' do
  owner 'nginx'
  group 'nginx'
  mode '0755'
end

service 'nginx' do
  action [:enable, :start]
end
