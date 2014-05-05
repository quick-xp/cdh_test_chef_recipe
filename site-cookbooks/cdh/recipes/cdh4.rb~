#
# Cookbook Name:: cdh
# Recipe:: default
#

template "cloudera.list" do
	path "/etc/apt/sources.list.d/cloudera.list"
	source "cloudera.list.erb"
	owner "root"
	group "root"
	mode 00744
end

bash "apt-get-update" do
	code "apt-get update"
end

bash "add-cdh-repository" do
	code "curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | apt-key add -"
end

package 'hadoop-0.20-mapreduce-jobtracker' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-hdfs-namenode' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-0.20-mapreduce-tasktracker' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-hdfs-datanode' do
	options "-f --force-yes"
	action :install
end

package 'hadoop-client' do
	options "-f --force-yes"
	action :install
end


#Copying the Hadoop Configuration
bash "Copying the Hadoop Configuration" do
	not_if { File.exists?("/etc/hadoop/conf.my_cluster")}
	code <<-EOS
	sudo cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.my_cluster
	sudo update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.my_cluster 50
	sudo update-alternatives --set hadoop-conf /etc/hadoop/conf.my_cluster
	chown -R root:hadoop /etc/hadoop/conf.my_cluster
	EOS
end

#設定ファイル(HDFS)
template "core-site.xml" do
	path "/etc/hadoop/conf.my_cluster/core-site.xml"
	source "cdh4/core-site.xml.erb"
	owner "root"
	group "hadoop"
	mode 00644
end

template "hdfs-site.xml" do
	path "/etc/hadoop/conf.my_cluster/hdfs-site.xml"
	source "cdh4/hdfs-site.xml.erb"
	owner "root"
	group "hadoop"
	mode 00644
end

#hdfsデータ格納用フォルダ作成
directory "/data" do
	owner "hdfs"
	group "hadoop"
	mode 00774
	action :create
end

directory "/data/1" do
	owner "hdfs"
	group "hadoop"
	mode 00774
	action :create
end

directory "/data/1/dfs" do
	owner "hdfs"
	group "hadoop"
	mode 00744
	action :create
end

directory "/data/1/dfs/nn" do
	owner "hdfs"
	group "hadoop"
	mode 00744
	action :create
end

directory "/data/1/dfs/dn" do
	owner "hdfs"
	group "hadoop"
	mode 00744
	action :create
end


#最初の一回しか実行できません。
#2回目以降は手動でコマンドを実行してください
bash "node format" do
	not_if { File.exists?("/usr/namenodeinstalled")}
	code <<-EOS
	sudo -u hdfs hadoop namenode -format
	touch /usr/namenodeinstalled
	EOS
end

#Service起動
service "hadoop-hdfs-namenode" do
	action :restart
end

service "hadoop-hdfs-datanode" do
	action :restart
end

#設定ファイル(MRv1)
template "mapred-site.xml" do
	path "/etc/hadoop/conf.my_cluster/mapred-site.xml"
	source "cdh4/mapred-site.xml.erb"
	owner "root"
	group "hadoop"
	mode 00644
end

#MapReduceデータ格納用フォルダ作成
directory "/data/1/mapred" do
	owner "mapred"
	group "hadoop"
	mode 00755
	action :create
end

directory "/data/1/mapred/local" do
	owner "mapred"
	group "hadoop"
	mode 00755
	action :create
end

#hdfs上にtmpディレクトリ作成
bash "create tmp directory on hdfs" do
        code <<-EOS
	sudo -u hdfs hadoop fs -mkdir /tmp
	sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
	EOS
	not_if "sudo -u hdfs hadoop fs -test -d /tmp"
end

#hdfs上に/varディレクトリ作成
bash "create var directory on hdfs" do
        code <<-EOS
	sudo -u hdfs hadoop fs -mkdir -p /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
	sudo -u hdfs hadoop fs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred/mapred/staging
	sudo -u hdfs hadoop fs -chmod -R 1777 /var/lib/hadoop-hdfs/cache/mapred
	EOS
	not_if "sudo -u hdfs hadoop fs -test -d /user/history"
end

bash "Create and Configure the mapred.system.dir Directory in HDFS" do
        code <<-EOS
	sudo -u hdfs hadoop fs -mkdir /tmp/mapred/system
	sudo -u hdfs hadoop fs -chown mapred:hadoop /tmp/mapred/system
	EOS
	not_if "sudo -u hdfs hadoop fs -test -d /user/history"
end



#Service起動
service "hadoop-0.20-mapreduce-tasktracker" do
	action :restart
end

service "hadoop-0.20-mapreduce-jobtracker" do
	action :restart
end


