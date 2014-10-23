# Author:: Nacer Laradji (<nacer.laradji@gmail.com>)
# Cookbook Name:: zabbix
# Recipe:: default
#
# Copyright 2011, Efactures
#
# Apache 2.0
#

unless node['zabbix']['agent']['skip']
  include_recipe 'zabbix::agent'
end
