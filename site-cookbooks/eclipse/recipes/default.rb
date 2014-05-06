#
# Cookbook Name:: eclipse
# Recipe:: default
#
# All rights reserved - Do Not Redistribute
#


package "pleiades"

execute "add pleiades.jar setting" do
	command "echo '-javaagent:/usr/share/eclipse/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar"
	not_if "cat /etc/eclipse.init | grep '-javaagent:/usr/share/eclipse/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar'"
end


