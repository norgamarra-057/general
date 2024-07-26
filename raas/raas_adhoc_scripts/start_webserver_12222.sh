cd /var/groupon/raas/
echo "/usr/local/bin/ruby -run -ehttpd . -p12222" > webserver_p12222.sh
nohup bash webserver_p12222.sh > webserver_p12222.log 2>&1 & 
echo "web server started"
