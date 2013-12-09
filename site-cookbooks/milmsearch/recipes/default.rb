#
# Cookbook Name:: milmsearch
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "milmsearch::user"
include_recipe "milmsearch::application_conf"
include_recipe "milmsearch::application"
include_recipe "milmsearch::supervisor"
include_recipe "milmsearch::iptables"