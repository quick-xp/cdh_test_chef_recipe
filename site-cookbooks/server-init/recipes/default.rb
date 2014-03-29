#
# Cookbook Name:: server-init
# Recipe:: default
#

USER = node["server-init"]["user"]
GROUP = node["server-init"]["group"]

group GROUP do
	group_name GROUP
	action [:create]
end

user USER do
	shell '/bin/bash'
	home '/home/' + USER
	password nil
	supports :manage_home => true, :non_unique => false
	action   [:create]
end

directory '/home/' + USER do
	owner USER
	group GROUP
	mode '0775'
	action :create
end
