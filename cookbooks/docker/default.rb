# frozen_string_literal: true
node.validate! do
  {
    docker: {
      users: array_of(string),
    },
  }
end

package 'docker'

service 'docker' do
  action [:enable, :start]
end

node.docker.users.each do |user|
  execute "usermod -aG docker #{user}"
end
