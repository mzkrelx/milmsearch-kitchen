#
# Cookbook Name:: milmsearch
# Recipe:: user
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

u = data_bag_item('users', 'milmsearch')

group u['group'] do
  action :create
end

# Add deploy 
user u['username'] do
  home  u['home']
  group u['group']
  shell u['shell']
  password nil
  supports :manage_home => true
end

# Make .ssh directory
directory "#{u['home']}/.ssh" do
  owner u['username']
  group u['group']
  mode 0700
  action :create
  only_if "test -d #{u['home']}"
end

# Copy ssh public key
file "#{u['home']}/.ssh/authorized_keys" do
  owner u['username']
  group u['group']
  mode 0600
  action :create
  content u['key']
end  

# no sudo password for user
# lines = { 'export PYENV_ROOT="\$HOME\/.pyenv"' => 'export PYENV_ROOT="$HOME/.pyenv"',
#   'export PATH="\$PYENV_ROOT\/bin:\$PATH"' => 'export PATH="$PYENV_ROOT/bin:$PATH"',
#   'eval "\$\(pyenv init -\)"' => 'eval "$(pyenv init -)"'}
# 
# file = Chef::Util::FileEdit.new("#{me['home']}/.bashrc")
# lines.each { |reg, line|
#   file.insert_line_if_no_match(/#{reg}/, line)
#   file.write_file
# }

file = Chef::Util::FileEdit.new("/etc/sudoers/")
file.insert_line_if_no_match(
  /%#{u['username']} ALL=\(ALL\) NOPASSWD: \/usr\/bin\/supervisorctl/, 
  "%#{u['username']} ALL=(ALL) NOPASSWD: /usr/bin/supervisorctl")
file.write_file
