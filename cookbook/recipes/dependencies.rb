#
# Cookbook Name:: runnable_lebowski
# Recipe:: dependencies
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

package 'git'

node.set['runnable_nodejs']['version'] = '0.10.28'
include_recipe 'runnable_nodejs'
