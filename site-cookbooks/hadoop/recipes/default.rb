#
# Cookbook Name:: hadoop
# Recipe:: default
#
#http://symfoware.blog68.fc2.com/blog-entry-1196.html
URL = node["hadoop"]["url"]
HadoopFileName = node["hadoop"]["filename"]

group "hadoop" do
	group_name "hadoop"
	action [:create]
end

user "hadoop" do
	group "hadoop"
	home "/home/hadoop"
	password nil
	shell "/bin/bash"
	supports :manage_home => true
	action   [:create]
end

directory "/usr/local/hadoop" do
	owner "hadoop"
	group "hadoop"
	mode 00764
	action :create
end

package "ssh"

bash "get-hadoop-file" do
	not_if { File.exists?("/usr/local/src/"+HadoopFileName+".tar.gz")}
	code <<-EOS
	cd /usr/local/src
	wget #{URL}
	tar zxf #{HadoopFileName}.tar.gz
	mv #{HadoopFileName} hadoop
	mv /usr/local/src/hadoop /usr/local
	chown -R hadoop:hadoop /usr/local/hadoop
	EOS
end

template ".bashrc" do
	path "/home/hadoop/.bashrc"
	source "bashrc.erb"
	owner "hadoop"
	group "hadoop"
	mode 00744
end



