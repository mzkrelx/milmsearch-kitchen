#
# Cookbook Name:: milmsearch
# Recipe:: supervisor
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "supervisor"

ruby_block "run_supervisord_on_boot" do
  block do
    file = Chef::Util::FileEdit.new("/etc/rc.local")
    file.insert_line_if_no_match("/usr/bin/supervisord", "/usr/bin/supervisord")
    file.write_file
  end
end

execute "start_supervisord" do
  user "root"
  cwd "/tmp"
  command "/usr/bin/supervisord --pidfile /var/run/supervisord.pid"
  creates "/var/run/supervisord.pid"
end
