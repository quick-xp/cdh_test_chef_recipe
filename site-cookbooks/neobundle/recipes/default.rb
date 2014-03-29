#
# Cookbook Name:: neobundle
# Recipe:: default
#

BUNDLE_HOME = "/home/" + node["neobundle"]["user"] + "/.vim/bundle"
USER = node["neobundle"]["user"]
GROUP = node["neobundle"]["group"]

directory BUNDLE_HOME do
	owner USER
	group GROUP
	mode 744
	action :create
	recursive true
end

git BUNDLE_HOME + "/neobundle.vim/" do
	user USER
	group GROUP
	repository "git://github.com/Shougo/neobundle.vim"
	revision "master"
	action :checkout
end

bash "chown" do
	cwd BUNDLE_HOME
	code "chown -R " << USER << ":" << GROUP << " " << BUNDLE_HOME << "&&" << "chmod -R 744 " << BUNDLE_HOME
end

template ".vimrc" do
	path BUNDLE_HOME + "/../../.vimrc"
	source "vimrc.erb"
	owner USER
	group GROUP
	mode 774
end

