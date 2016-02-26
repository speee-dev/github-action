# frozen_string_literal: true
package 'golang'

SRC_DIR = '/usr/local/src/direnv'

git SRC_DIR do
  repository 'https://github.com/direnv/direnv.git'
end

execute 'make install' do
  cwd SRC_DIR
  not_if 'test -e /usr/local/bin/direnv'
end

remote_file '/etc/profile.d/direnv.sh' do
  owner 'root'
  group 'root'
  mode '0644'
end
