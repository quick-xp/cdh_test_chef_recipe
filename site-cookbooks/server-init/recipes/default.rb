#
# Cookbook Name:: server-init
# Recipe:: default
#

USER = node["server-init"]["user"]
GROUP = node["server-init"]["group"]
HOME = '/home/' + USER

# install zsh
package 'zsh'

group GROUP do
	group_name GROUP
	action [:create]
end

user USER do
	shell '/bin/zsh'
	home '/home/' + USER
	password nil
	supports :manage_home => true, :non_unique => false
	action   [:create]
end

template ".zshrc" do
	path HOME + "/.zshrc"
	source "zshrc.erb"
	owner USER
	group GROUP
	mode 00744
end

directory HOME + "/plugin/" do
	owner USER
	group GROUP
	mode 00764
	action :create
end

git HOME + "/plugin/auto-fu.zsh" do
	user USER
	group GROUP
	repository "https://github.com/hchbaw/auto-fu.zsh.git"
	revision "master"
	action :checkout
end

