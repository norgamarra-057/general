
# #############################################################################
# The actual override_slavelag_check which is invoked by the plugin classes
# #############################################################################

# Allows to set the max lag on a per server 
# mysql> select * from percona.max_lag;
# +----+---------------+---------+
# | id | name          | max_lag |
# +----+---------------+---------+
# |  1 | test-db4.snc1 |      60 |
# +----+---------------+---------+
# 1 row in set (0.00 sec)

{
package plugin_heartbeat;

sub get_slave_lag {
   my ($self, %args) = @_;
   # oktorun is a reference, also update it using $$oktorun=0;
   my $oktorun=$args{oktorun};
   
   my $heartbeattable="percona.heartbeat";
   my $maxlagtable="percona.max_lag";

   print "PLUGIN get_slave_lag: pt-heartbeat will be checked\n";

   my $get_lag = sub {

## 3 lines Added by Ammon 2017-04-03
   my $maximum = 10;
   my $random_number = int(rand($maximum));
   if ($random_number == 5) {
         my ($cxn) = @_;
         $cxn->{dsn_name} =~ /^h=(.*)$/;
         my $this_db_server = $1;
         my $dbh = $cxn->dbh();
   
         if ( !$dbh || !$dbh->ping() ) {
            eval { $dbh = $cxn->connect() }; # connect or die trying
            if ( $EVAL_ERROR ) {
               chomp $EVAL_ERROR;
               $$oktorun=0;
               # die "Lost connection to replica " . $cxn->name()
               #    . " while attempting to get its lag ($EVAL_ERROR)\n";
               # TODO: temporary workaround for reconnecting in case of a slave failure, examine later
               return 10000;
            }
         }

         # If replication is not running, then it should be properly reported

         my $slavestatus = $dbh->selectrow_hashref("SHOW SLAVE STATUS");
         if ( ($slavestatus->{slave_io_running} ne "Yes")
             || ($slavestatus->{slave_sql_running} ne "Yes") ) {
            return;
         }

         my $res_max_lag;

         eval {
            $res_max_lag = $dbh->selectrow_hashref("SELECT max_lag FROM $maxlagtable WHERE name='$this_db_server'");
         };

         my $max_lag = $res_max_lag->{max_lag} || 0;

         my $res = $dbh->selectrow_hashref(
            "SELECT min(unix_timestamp(now()) - unix_timestamp(concat(substr(ts,1,10),' ',substr(ts,12,8)))) as lag_sec
             FROM $heartbeattable");

         my $lag_sec = $res->{lag_sec};

         # The max_lag thing should be transparent, we simply substract the allowable lag
         my $lag_ret = $lag_sec - $max_lag;

         # we return oktorun and the lag
         return $lag_ret;
## 3 lines Added by Ammon 2017-04-03
      }else{
         my $lag_ret = 0 - 1;
         return $lag_ret;
      }
##
   };

   return $get_lag;
}
}
1;
# #############################################################################
# pt_online_schema_change_plugin
# #############################################################################
{
package pt_online_schema_change_plugin;

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);
use constant PTDEBUG => $ENV{PTDEBUG} || 0;

sub new {
   my ($class, %args) = @_;
   my $self = { %args };
   return bless $self, $class;
}

sub get_slave_lag {
   return plugin_heartbeat::get_slave_lag(@_);
}
}
1;

# #############################################################################
# pt_table_checksum_plugin
# #############################################################################
{
package pt_table_checksum_plugin;

use strict;
use warnings FATAL => 'all';
use English qw(-no_match_vars);
use constant PTDEBUG => $ENV{PTDEBUG} || 0;

sub new {
   my ($class, %args) = @_;
   my $self = { %args };
   return bless $self, $class;
}

sub get_slave_lag {
   return plugin_heartbeat::get_slave_lag(@_);
}
}
1;

