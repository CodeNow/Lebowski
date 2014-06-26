#
# Cookbook Name:: runnable_lebowski
# Recipe:: nodejs
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

node.set['runnable_nodejs']['version'] = '0.10.28'
include_recipe 'runnable_nodejs'

execute 'install pm2' do
  command 'npm install pm2 -g'
  action :run
end
