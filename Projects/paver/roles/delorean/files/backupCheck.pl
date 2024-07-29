#!/usr/bin/env perl

use warnings;
use strict;
use LWP::UserAgent;
use Net::Domain qw(hostname hostfqdn hostdomain);
use Data::Dumper;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP ();


if ($#ARGV + 1 != 4) {
    print "Usage: $0 sshReturnCode database pool template\n";
    exit;
}


my $sshReturnCode=$ARGV[0];
my $dbBackup=$ARGV[1];
my $pool=$ARGV[2];
my $template=$ARGV[3];
my $delorean='/var/groupon/delorean/';
my $logPath=$delorean.'logs/';
my $dataPath=$delorean.'pools/'.$pool.'/'.$template.'/';
my $fqdn = hostfqdn();
my $datacenter=hostdomain();

my %form =(
	run_every=>86400,# (24h:86400, 12h:43200)
	path=>"infrastructure/${fqdn}",
	monitor=>"backup_".$dbBackup,
);

#check the return code of ssh
#check if the log exist
#check if the backup end up with 'completed OK!'

#check if sshReturn code is an int and if it's not 0 (in case previous 
#backup success but the current one wasn't able to connect)
if (!($sshReturnCode !~ /\D/ and $sshReturnCode eq 0)) {	
	$form{'status'}=2;
	$form{'output'}="CRITICAL - ssh returned a non zero status ($dbBackup) |code=$sshReturnCode,name=$dbBackup";
#check if the log file exist (currently can't fail the check unless this is run before 
#a single backup...)
} elsif (open (FILE, $logPath.$dbBackup.".log")) {
	#go to the last line (constant time)
	my $pos = -2;
	my $char='';
	while($char ne "\n") {
		seek FILE, $pos, 2;
		read FILE, $char, 1;
		$pos--;
	}
	my $final = <FILE>; #grab the last line
	chomp($final);
	#check if the backup succeed
	if ($final =~ /completed OK\!$/) {
	
		my $backupSize = -s $dataPath.$dbBackup."/".$dbBackup."-".$template.".tar.gz";
		$form{'status'}=0;
		#var=value;warning;critical
		$form{'output'}="OK - Nothing to See Here ($dbBackup) | backupSize=$backupSize,name=$dbBackup";
	} else {
		$form{'status'}=2;
		$form{'output'}="CRITICAL - $final ($dbBackup) | name=$dbBackup";		
	}
	close (FILE);
#if the log file don't exist
} else {
		$form{'status'}=2;
		$form{'output'}="CRITICAL - $logPath$dbBackup.log: No such file or directory. ($dbBackup) | name=$dbBackup";
}

#push the result to monitord, who will push it to nagios
my $ua = LWP::UserAgent->new();
my $resp = $ua->post(
	"http://monitord.${datacenter}:8080/results", #VIP in the datacenter
	"Content_Type" => "application/x-www-form-urlencoded",
	"Accept" => "*/*",
	"User-Agent" => "BackupChecker",
	"Content" => \%form,
);

########################################################################
#Unfortunately our jobs are not compatible with groupon monitoring...
#We choose this instead of adding 1 new check on each server or 200 on 
#the backup server in ops-config/hosts/*.yml
########################################################################
my $transport = Email::Sender::Transport::SMTP->new({host => 'smtp.'.$datacenter});
my $email = Email::Simple->create(
  header => [
    To      => 'prod-syseng-alerts@groupon.com',
    From    => 'mreussner@groupon.com',
    Subject => "Delorean backup ".$dbBackup." : ".$form{'status'},
  ],
  body => $form{'output'}."\n",
);

sendmail($email, { transport => $transport });
########################################################################

print $form{'output'}."\n";
exit($form{'status'});
