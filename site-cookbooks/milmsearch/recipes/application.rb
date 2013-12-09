#
# Cookbook Name:: milmsearch
# Recipe:: application
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package_name = "milmsearch-1.0.0"
binary_url = "https://github.com/mzkrelx/milmsearch/releases/download/v1.0.0/#{package_name}.tgz"
u = data_bag_item('users', 'milmsearch')

# Make donwloads directory
directory "#{u['home']}/downloads" do
  owner u['username']
  group u['group']
  mode 0755
  action :create
  only_if "test -d #{u['home']}"
end

# Download binary package file
remote_file "#{u['home']}/downloads/#{package_name}.tgz" do
  source binary_url
  owner u['username']
  group u['group']
  action :create_if_missing
end

execute "expand" do
  user u['username']
  group u['group']
  cwd u['home']
  command "tar zxvf #{u['home']}/downloads/#{package_name}.tgz -C #{u['home']}; rm -rf target; mv #{package_name} target"
end
