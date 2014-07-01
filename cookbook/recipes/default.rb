#
# Cookbook Name:: runnable_lebowski
# Recipe:: default
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'runnable_lebowski::dependencies'
include_recipe 'runnable_lebowski::deploy_ssh'
include_recipe 'runnable_lebowski::deploy'
