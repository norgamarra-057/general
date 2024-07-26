cd /var/groupon/www/current/
sudo -H -u deploy_user /home/deploy_user/.rbenv/bin/rbenv exec bundle exec puma -C /var/groupon/www/shared/puma.rb --daemon

