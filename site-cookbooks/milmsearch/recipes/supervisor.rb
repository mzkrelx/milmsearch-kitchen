#
# Cookbook Name:: milmsearch
# Recipe:: supervisor
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "supervisor"

# まだopscodeのレシピでCentOS対応してないので自動起動だけここでする 
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
  command "/usr/bin/supervisord"
  creates "/var/run/supervisord.pid"
end

supervisor_service "milmsearch" do
  command "/usr/local/milmsearch/target/start -Dconfig.file=/usr/local/milmsearch/conf/application-production.conf -DapplyEvolutions.default=true"
  process_name "milmsearch"
  user "milmsearch"
  stdout_logfile "/var/log/milmsearch.log"
  stderr_logfile "/var/log/milmsearch-err.log"
end
