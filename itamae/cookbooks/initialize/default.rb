# frozen_string_literal: true
%w(i18n clock).each do |f|
  remote_file "/etc/sysconfig/#{f}" do
    owner 'root'
    group 'root'
    mode '0644'
  end
end

execute 'cp -p /etc/localtime{,.orig}' do
  not_if 'test -e /etc/localtime.orig'
end

link '/etc/localtime' do
  to '/usr/share/zoneinfo/Asia/Tokyo'
  force true
end

service 'crond' do
  action [:restart]
end
