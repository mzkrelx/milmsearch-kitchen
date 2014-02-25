#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "nginx" do
  action :install
  not_if "rpm -q nginx"
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/nginx/conf.d/default.conf" do
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end

# If you have crt file, please comment in.
# cookbook_file "/etc/nginx/server.crt" do
#   owner "root"
#   group "root"
#   mode 0600
# end

# If you have key file, please comment in.
# cookbook_file "/etc/nginx/server.key" do
#   owner "root"
#   group "root"
#   mode 0600
# end

template "/etc/nginx/conf.d/ssl.conf" do
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end

# install "htpasswd"
package "httpd-tools" do
  action :install
  not_if "rpm -q httpd-tools"
end

admin = Chef::EncryptedDataBagItem.load("basic_auth", "admin", "data_bag_key/secret_key")
htpasswd "/etc/nginx/conf.d/.htpasswd" do
  user "#{admin['user']}"
  password "#{admin['password']}"
  notifies :reload, "service[nginx]"
end
