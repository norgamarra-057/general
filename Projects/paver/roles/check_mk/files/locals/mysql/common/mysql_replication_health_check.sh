#!/usr/bin/env bash

# Check pf status and raise critical error if it is not enabled

function check_repl
{
  /usr/local/sbin/check_repl.sh >/dev/null 2>&1
  _retcode=$?
  if [ $_retcode -eq 0 ]; then
    echo "result=$_retcode; OK - no mysql replication issues on server"
    _retcode=0
  else
    echo "result=$_retcode; CRIT - ${_retcode} mysql replication issue(s) on this server"
    _retcode=2
  fi
  return $_retcode
}

ServiceDescription="mysql_replication_health"
Output=$(check_repl)
ExitCode=$?

echo "$ExitCode $ServiceDescription $Output"
exit 0
