#!/usr/bin/perl
use File::Find;
use warnings;
use strict;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP ();
use POSIX qw(strftime);

#yeah that's global
my $email='';

File::Find::find({wanted => \&wanted}, '/var/groupon/delorean/jobs/daily/');

if($email ne ''){
	$email="The following db have not been backed up during the last 24h\n\n".$email;
} else {
	$email="All backup have been executed during the last 24h\n";
}

my $transport = Email::Sender::Transport::SMTP->new({host => 'smtp.snc1'});
my $emailContent = Email::Simple->create(
	header => [
	To      => 'prod-syseng-alerts@groupon.com',
	From    => 'mreussner@groupon.com',
	Subject => "Daily report for delorean missing backup",
],
body => $email,
);
sendmail($emailContent, { transport => $transport });


sub wanted {
	my $job=$_;
    return if($job =~ /^.{1,2}$/);
    my $log=$job;
	
	$log =~ s/\.sh$/\.log/g;
	    
	my ($devLog,$mtimeLog)= (stat("/var/groupon/delorean/logs/".$log))[0,9];
	my ($devJob,$mtimeJob)= (stat($job))[0,9];
	
	#don't alert if the job is younger than 1 day
    return if (time()-$mtimeJob < 86400);
    #if the log exist and is younger than 24h it's all good
	return if (defined($devLog) and (time()-$mtimeLog < 86400));

	alert($job,$mtimeLog);
}



sub alert{
	my ($dbName,$age)=@_;
	$dbName =~ s/\.sh$//g;
	$email.=$dbName.' : '.(defined($age) ? strftime ("%F %T", localtime($age)) : 'log missing' )."\n";
}
