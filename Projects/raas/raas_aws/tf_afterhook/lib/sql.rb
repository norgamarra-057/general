#########################################
# Temporary solution
#########################################
def write_sql_tmp_files(tf)
	# mysql.server start
	# mysql -uroot
  #
	# create database ec;
	# use ec;
	# CREATE TABLE IF NOT EXISTS clusters (
	# 	cluster_name VARCHAR(255) NOT NULL,
	#   tpl_name VARCHAR(255) NOT NULL,
	#   ticket VARCHAR(255) NOT NULL,
	#   service VARCHAR(255) NOT NULL,
	#   engine VARCHAR(255) NOT NULL,
	#   engine_version VARCHAR(255) NOT NULL,
	#   node_type VARCHAR(255) NOT NULL,
	#   num_nodes TINYINT NOT NULL,
	#   cname VARCHAR(255) NOT NULL,
	#   PRIMARY KEY (cluster_name)
	# ) ENGINE=INNODB;
	#
	# mysql -uroot --database=ec --execute="TRUNCATE TABLE clusters"
	# mysql -uroot --database=ec < /tmp/raas_ec.*.*.sql
	# mysql -uroot --database=ec
	#
	File.open("/tmp/raas_ec.#{tf.aws_region}.#{tf.env}.#{tf.engine}.sql", 'w') do |file|
		tf.instances.each do |i|
			keys = i.keys.join(',')
			values = i.values.map{|e| "\"#{e}\"" }.join(',')
			file.write "INSERT INTO clusters (#{keys}) VALUES (#{values});\n"
		end
	end

end
#########################################
