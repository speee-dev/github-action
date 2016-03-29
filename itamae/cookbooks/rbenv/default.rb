# frozen_string_literal: true
node.validate! do
  {
    rbenv: {
      versions: array_of(string),
      global:   string,
      gems:     array_of(string),
    },
  }
end

package 'epel-release'
package 'gcc'
package 'openssl-devel'
package 'libyaml-devel'
package 'readline-devel'
package 'zlib-devel'
package 'libxml2'
package 'libxml2-devel'
package 'libxslt'
package 'libxslt-devel'
package 'git'
package 'mysql-devel'

RBENV_DIR = '/usr/local/rbenv'
RBENV_SCRIPT = '/etc/profile.d/rbenv.sh'

git RBENV_DIR do
  repository 'git://github.com/sstephenson/rbenv.git'
end

remote_file RBENV_SCRIPT do
  owner 'root'
  group 'root'
  mode '0644'
end

directory "#{RBENV_DIR}/plugins" do
  owner 'root'
  group 'root'
  mode '0755'
end

git "#{RBENV_DIR}/plugins/ruby-build" do
  repository 'git://github.com/sstephenson/ruby-build.git'
end

node.rbenv.versions.each do |version|
  execute "install ruby #{version}" do
    command "source #{RBENV_SCRIPT}; rbenv install #{version}"
    not_if "source #{RBENV_SCRIPT}; rbenv versions | grep #{version}"
  end
end

execute "set global ruby #{node.rbenv.global}" do
  command "source #{RBENV_SCRIPT}; rbenv global #{node.rbenv.global}; rbenv rehash"
  not_if "source #{RBENV_SCRIPT}; rbenv global | grep #{node.rbenv.global}"
end

node.rbenv.gems.each do |g|
  execute "gem install #{g}" do
    command "source #{RBENV_SCRIPT}; gem install #{g}; rbenv rehash"
    not_if "source #{RBENV_SCRIPT}; gem list | grep #{g}"
  end
end
