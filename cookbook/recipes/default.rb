#
# Cookbook Name:: runnable_lebowski
# Recipe:: default
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'runnable_base'

include_recipe 'runnable_lebowski::nodejs'
include_recipe 'runnable_lebowski::deploy'
