#
# Cookbook Name:: server-init
# Recipe:: default
#

USER = node["server-init"]["user"]
GROUP = node["server-init"]["group"]

group 'server-init' do
	group_name GROUP
	action [:create]
end

user 'server-init' do
	user USER
	supports :manage_home => true, :non_unique => false
	action   [:create]
end

